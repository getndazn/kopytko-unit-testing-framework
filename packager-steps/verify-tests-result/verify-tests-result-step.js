const AppDeployer = require('@kopytko/packager/src/core/app-deployer');
const Step = require('@kopytko/packager/src/step-runner/steps/step');
const TestResultsFetcher = require('./test-results-fetcher');

module.exports = class VerifyTestsResultStep extends Step {
  static TITLE = 'Running unit tests';

  /**
   * Fetches the output from telnet and parses it into results. Compatible with Roku Unit Test Framework.
   *
   * @param {Object} config
   * @param {String} config.rokuIP
   * @param {String} config.rokuDevUser
   * @param {String} config.rokuDevPassword
   */
  async run({ rokuIP, rokuDevUser, rokuDevPassword  }) {
    const resultsFetcher = new TestResultsFetcher(rokuIP);
    const result = await resultsFetcher.fetch();

    await new Promise(resolve => setTimeout(resolve, 1000)); // without wait Roku crashes when trying to uninstall
    const deployer = new AppDeployer({ rokuIP, rokuDevUser, rokuDevPassword });
    await deployer.uninstallCurrentApp();

    return result;
  }
}
