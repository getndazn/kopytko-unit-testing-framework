const RokuError = require('@dazn/kopytko-packager/src/errors/roku-error');

module.exports = class UnitTestsOutputInterpreter {
  // Roku timestamps appear on system lines as: MM-DD HH:MM:SS.mmm
  // e.g. "03-24 16:34:42.505 sdkl [beacon.signal] ..."
  _ROKU_TIMESTAMP_REGEX = /^\d{2}-\d{2} (\d{2}):(\d{2}):(\d{2})\.\d{3}/;

  _accumulatedData = [];
  _isCurrentRunStarted = false;
  _isWaitingForRuntimeErrorDetails = false;
  _failedTestsLines = [];
  _startSecondsOfDay = 0;
  _lineBuffer = '';

  _resultReject; /** @type {function} */
  _resultResolve; /** @type {function} */

  constructor(startTime = new Date()) {
    // Roku debug log timestamps (port 8085) are always UTC regardless of device timezone.
    // Use UTC hours to compare against Roku log timestamps correctly.
    // Allow a small buffer for device clock skew.
    const rawSeconds = startTime.getUTCHours() * 3600 + startTime.getUTCMinutes() * 60 + startTime.getUTCSeconds();

    this._startSecondsOfDay = Math.max(0, rawSeconds - 3);
  }

  waitForResults() {
    return new Promise((resolve, reject) => {
      this._resultResolve = resolve;
      this._resultReject = reject;
    });
  }

  process(data) {
    const dataString = this._lineBuffer + data.toString();
    const dataLines = dataString.split(/\r?\n/);

    this._lineBuffer = dataLines.pop();

    const currentRunLines = [];
    for (const line of dataLines) {
      if (this._isCurrentRunStarted) {
        currentRunLines.push(line);
        continue;
      }

      const lineSeconds = this._getLogLineSecondsOfDay(line);
      if (lineSeconds !== null && lineSeconds >= this._startSecondsOfDay) {
        this._isCurrentRunStarted = true;
        currentRunLines.push(line);
      }
    }

    if (currentRunLines.length === 0) return;

    this._accumulatedData.push(...currentRunLines);

    const resultLines = currentRunLines.filter(line => line.includes('Total') && line.includes('Passed'));
    const failedTestsLines = currentRunLines.filter(line => line.includes('---  ') || line.includes('---------') && !line.includes('[beacon.'));

    this._failedTestsLines.push(...failedTestsLines);

    if (resultLines[0]) {
      const results = this._getTestsResults(resultLines[0]);

      return this._resultResolve({ results, failedTestsLines: this._failedTestsLines });
    }

    const runtimeErrorLineIndex = currentRunLines.findIndex(line => line.includes('runtime error'));
    if (runtimeErrorLineIndex > -1) {
      this._isWaitingForRuntimeErrorDetails = true;
    }

    if (this._isWaitingForRuntimeErrorDetails) {
      const selectedThreadMarkLineIndex = currentRunLines.findIndex(line => line.includes('*selected'));
      if (selectedThreadMarkLineIndex > -1) {
        const errorDetailsStartLineIndex = this._accumulatedData.findIndex(line => line.includes('Thread selected:'));

        return this._resultReject(new RokuError('Runtime error', this._accumulatedData.slice(errorDetailsStartLineIndex)));
      }
    }
  }

  _getTestsResults(summaryString) {
    return {
      total: this._getTestsResultsProperty(summaryString, 'Total'),
      passed: this._getTestsResultsProperty(summaryString, 'Passed'),
      failed: this._getTestsResultsProperty(summaryString, 'Failed'),
    };
  }

  _getTestsResultsProperty(summaryString, property) {
    return parseInt(
      this._getPropertyRegex(property).exec(summaryString)[1], 10,
    );
  }

  // The current results line in telnet looks like:
  // ***   Total  = 145 ; Passed  =  139 ; Failed   =  6 ; Skipped   =  0 ; Crashes  =  0 Time spent:  1165ms
  _getPropertyRegex(property) {
    return new RegExp(`${property}\\s*=\\s*(\\d+)`, 'g');
  }

  _getLogLineSecondsOfDay(line) {
    const match = this._ROKU_TIMESTAMP_REGEX.exec(line);
    if (!match) return null;

    return parseInt(match[1], 10) * 3600 + parseInt(match[2], 10) * 60 + parseInt(match[3], 10);
  }
}
