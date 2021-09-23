const TestSuite = require('./test-suite');
const TestSuitesFinder = require('./test-suites-finder');
const UnitFinder = require('./unit-finder');
const KopytkoError = require('@dazn/kopytko-packager/src/errors/kopytko-error');

const TESTS_DIRECTORY = '_tests/';

module.exports = class TestSchema {
  static async load(filePath) {
    const mainTestSuite = new TestSuite(filePath, true);
    const unit = await new UnitFinder(TESTS_DIRECTORY).find(mainTestSuite);

    if (!unit) {
      throw new KopytkoError(`TestSchema: Cannot find tested element for ${filePath}`);
    }

    const testSuites = await new TestSuitesFinder(TESTS_DIRECTORY).find(unit);

    return new TestSchema(unit, [mainTestSuite, ...testSuites]);
  }

  constructor(unit, testSuites) {
    this.unit = unit;
    this.testSuites = testSuites;
    this.name = `${unit.name}${TestSuite.SEPARATOR}`;
  }
}

