const net = require('net');
const { execSync } = require('child_process');

const KopytkoError = require('@dazn/kopytko-packager/src/errors/kopytko-error');
const RokuError = require('@dazn/kopytko-packager/src/errors/roku-error');
const UnitTestsOutputInterpreter = require('./unit-tests-output-interpreter');

module.exports = class TestResultsFetcher {
  _CONNECTION_PORT = 8085;
  _CONNECTION_TIMEOUT = 10000;
  _FIRST_DATA_TIMEOUT = 5000; // stale connection: socket connected but Roku sends nothing
  _MAX_RETRIES = 8;
  _RESULTS_TIMEOUT = 5400000; // 90 minutes — covers even the longest full test suite

  _outputInterpreter;
  _rokuIP;

  constructor(rokuIP) {
    this._outputInterpreter = new UnitTestsOutputInterpreter();
    this._rokuIP = rokuIP;
  }

  /**
   * Kills any local process currently connected to Roku's debug port 8085,
   * then waits briefly for the TCP connection to fully close.
   * Used with --forceConnect to break an existing debug session.
   */
  async forceDisconnectExistingClients() {
    let pids;

    try {
      pids = execSync(`lsof -t -i @${this._rokuIP}:${this._CONNECTION_PORT} 2>/dev/null`, { encoding: 'utf8' })
        .trim()
        .split('\n')
        .filter(Boolean)
        .map(Number)
        .filter(pid => pid > 0 && pid !== process.pid);
    } catch (_) {
      return; // lsof not available or no matches
    }

    if (pids.length === 0) return;

    for (const pid of pids) {
      try {
        process.kill(pid);
        console.log(`[test-results-fetcher] --forceConnect: killed process ${pid} holding port 8085`);
      } catch (_) {
        // Process may have already exited
      }
    }

    // Brief pause for TCP FIN to propagate and Roku to release the port
    await new Promise(resolve => setTimeout(resolve, 1000));
  }

  async fetch() {
    const startTime = new Date();
    const deadline = startTime.getTime() + this._RESULTS_TIMEOUT;
    let lastError;
    let attempt = 0;

    while (Date.now() < deadline) {
      this._outputInterpreter = new UnitTestsOutputInterpreter(startTime);

      try {
        const socket = await this._connect();

        return await this._waitForResults(socket, deadline);
      } catch (error) {
        lastError = error;

        if (error instanceof RokuError) throw error;
        if (Date.now() >= deadline) break;

        if (error.portInUse) {
          throw new KopytkoError(
            'Console port 8085 is occupied by another client. ' +
            'Close the existing connection or run with --forceConnect to break it.',
          );
        } else {
          attempt++;
          if (attempt > this._MAX_RETRIES) break;
          await new Promise(resolve => setTimeout(resolve, 1000));
        }
      }
    }

    throw lastError || new KopytkoError('Test results timeout — no results received within 5 minutes');
  }

  _connect() {
    return new Promise((resolve, reject) => {
      const socket = net.createConnection({
        host: this._rokuIP,
        port: this._CONNECTION_PORT,
      });

      const timeout = setTimeout(() => {
        socket.destroy();
        reject(new KopytkoError('Telnet connection timeout'));
      }, this._CONNECTION_TIMEOUT);

      socket.once('connect', () => {
        clearTimeout(timeout);
        resolve(socket);
      });

      socket.once('error', (error) => {
        clearTimeout(timeout);
        reject(new KopytkoError(`Telnet connection error: ${error.message}`));
      });
    });
  }

  _waitForResults(socket, deadline) {
    // Ensure the socket is closed if the process is killed (prevents zombie connections on Roku).
    const cleanup = () => { try { socket.destroy(); } catch (_e) { /* ignore */ } };

    process.once('SIGINT', cleanup);
    process.once('SIGTERM', cleanup);

    return new Promise((resolve, reject) => {
      let settled = false;
      let hasReceivedData = false;

      const remainingTime = Math.max(deadline - Date.now(), 10000);
      const overallTimeout = setTimeout(() => {
        settle(reject, new KopytkoError('Test results timeout — no results received within 90 minutes'));
      }, remainingTime);

      // Only guard: if the socket connects but Roku sends nothing, reconnect fast.
      // Once data starts, we stay connected and wait — long test runs can have gaps between test files.
      const firstDataTimer = setTimeout(() => {
        if (!hasReceivedData) {
          settle(reject, new KopytkoError('No data received after connect — reconnecting'));
        }
      }, this._FIRST_DATA_TIMEOUT);

      const settle = (fn, value) => {
        if (settled) return;
        settled = true;
        process.removeListener('SIGINT', cleanup);
        process.removeListener('SIGTERM', cleanup);
        clearTimeout(overallTimeout);
        clearTimeout(firstDataTimer);
        socket.removeAllListeners('data');
        socket.removeAllListeners('close');
        socket.removeAllListeners('error');
        socket.end();
        setTimeout(() => socket.destroy(), 500);
        fn(value);
      };

      socket.on('data', (data) => {
        hasReceivedData = true;
        const str = data.toString();

        if (str.includes('Console connection is already in use')) {
          const err = new KopytkoError('Console port 8085 is already in use by another client');
          err.portInUse = true;
          settle(reject, err);

          return;
        }

        this._outputInterpreter.process(data);
      });

      socket.on('close', () => {
        if (!settled) {
          settle(reject, new KopytkoError('Telnet connection closed unexpectedly — check device connectivity.'));
        }
      });

      socket.on('error', (error) => {
        settle(reject, new KopytkoError(`Telnet error: ${error.message}`));
      });

      this._outputInterpreter.waitForResults()
        .then(({ results, failedTestsLines }) => {
          const { total, passed, failed } = results;
          const result = `Total: ${total} | Passed: ${passed} | Failed: ${failed}`;

          if (total !== passed) {
            settle(reject, new RokuError(result, failedTestsLines));
          } else {
            settle(resolve, result);
          }
        })
        .catch(error => settle(reject, error));
    });
  }

  _isPortInUse() {
    return new Promise((resolve) => {
      const socket = net.createConnection({ host: this._rokuIP, port: this._CONNECTION_PORT });
      let decided = false;

      const decide = (inUse) => {
        if (decided) return;
        decided = true;
        socket.removeAllListeners();
        socket.end();
        setTimeout(() => socket.destroy(), 300);
        resolve(inUse);
      };

      const connectionTimeout = setTimeout(() => decide(false), this._CONNECTION_TIMEOUT);

      socket.once('connect', () => {
        clearTimeout(connectionTimeout);
        // Wait briefly for Roku to send the "in use" message if applicable
        const dataTimeout = setTimeout(() => decide(false), 1500);

        socket.once('data', (data) => {
          clearTimeout(dataTimeout);
          decide(data.toString().includes('Console connection is already in use'));
        });
      });

      socket.once('error', () => {
        clearTimeout(connectionTimeout);
        decide(false);
      });
    });
  }
}
