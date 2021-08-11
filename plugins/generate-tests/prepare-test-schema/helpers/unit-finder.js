const glob = require('glob-promise');

const Unit = require('./unit');
const TestSuite = require('./test-suite');

const FILE_EXTENSION_PATH_PATTERN = '*.{brs,xml}';
const FILE_NAME_REGEX = /[^/]+(?=.(brs|xml))/;

module.exports = class UnitFinder {
  constructor(testsDir) {
    this._testsDir = testsDir;
  }

  async find(mainTestSuite) {
    const parentDirFilesPaths = await this._getTestParentDirFiles(mainTestSuite);
    const normalizedTestName = this._normalizeFileName(mainTestSuite.name);

    for (const filePath of parentDirFilesPaths) {
      const fileName = filePath.match(FILE_NAME_REGEX)[0];
      const normalizedFileName = this._normalizeFileName(fileName);

      if (normalizedFileName === normalizedTestName) {
        const name = mainTestSuite.name.split(TestSuite.SEPARATOR)[0];

        return new Unit(name, filePath, fileName);
      }
    }
  }

  async _getTestParentDirFiles(mainTestSuite) {
    const parentDirPath = mainTestSuite.filePath.split(this._testsDir)[0];
    const parentDirFilesPaths = await glob(parentDirPath + FILE_EXTENSION_PATH_PATTERN);
    parentDirFilesPaths.sort(filePath => -filePath.endsWith('.xml'));

    return parentDirFilesPaths;
  }

  _normalizeFileName(fileName) {
    return fileName
      .replace(/[.]|component/g, '')
      .split(TestSuite.SEPARATOR)[0]
      .toLowerCase();
  }
}
