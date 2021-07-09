const glob = require('glob-promise');

const TestSuite = require('./test-suite');

module.exports = class TestSuitesFinder {
  constructor(testsDir) {
    this._testsDir = testsDir;
  }

  async find(unit) {
    const testSuitePattern = `${unit.fileLocation}${this._testsDir}**/${unit.name}${TestSuite.SEPARATOR}*`;
    const testSuitesFilesPaths = await glob(testSuitePattern);

    return testSuitesFilesPaths.map(filePath => new TestSuite(filePath));
  }
}
