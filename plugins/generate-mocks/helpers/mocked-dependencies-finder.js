const glob = require('glob-promise');
const path = require('path');
const FileHandler = require('@kopytko/packager/src/plugin-helpers/file-handler');

const BrightscriptDependencies = require('../../import-dependencies/helpers/brightscript/unit-testing-brightscript-dependencies');

const IGNORED_TEST_FILES_PATH_PATTERN = '/components/**/_tests/**/*_*.brs';
const TEST_FILES_PATH_PATTERN = '/components/**/_tests/**/*.test.brs';

module.exports = class MockedDependenciesFinder {
  constructor(rootDir) {
    this._rootDir = rootDir;
  }

  async find() {
    const mockedDependencies = [];
    const testFilePaths = await glob(path.join(this._rootDir, TEST_FILES_PATH_PATTERN), {
      ignore: path.join(this._rootDir, IGNORED_TEST_FILES_PATH_PATTERN),
    });

    (await Promise.all(testFilePaths.map(filePath => this._getFileMockPaths(filePath))))
      .forEach(mockPaths => mockedDependencies.push(...new Set(mockPaths)));

    return mockedDependencies;
  }

  async _getFileMockPaths(filePath) {
    const fileLines = await FileHandler.readLines(filePath);
    const brightscriptDependencies = new BrightscriptDependencies(fileLines, filePath, this._rootDir);

    return brightscriptDependencies.getMockPaths();
  }
}
