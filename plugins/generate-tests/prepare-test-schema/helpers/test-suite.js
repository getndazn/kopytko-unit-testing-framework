const KopytkoError = require('@dazn/kopytko-packager/src/errors/kopytko-error');

const TEST_SUITE_NAME_REGEX = /[^/]+(?=.test.brs)/;

module.exports = class TestSuite {
  static get SEPARATOR() {
    return '_';
  }

  constructor(filePath, isMain) {
    this.filePath = filePath;
    this.isMain = isMain;
    const nameMatch = filePath.match(TEST_SUITE_NAME_REGEX);
    if (!nameMatch) {
      throw new KopytkoError(`Test suite "${filePath}" has improper name. Did you forget about ".test" postfix?`);
    }

    this.name = nameMatch[0];
    // main test suite doesn't contain separator so we have to add it
    this.outputFileName = `Test__${nameMatch[0]}${isMain ? TestSuite.SEPARATOR : ''}.brs`;
  }
}
