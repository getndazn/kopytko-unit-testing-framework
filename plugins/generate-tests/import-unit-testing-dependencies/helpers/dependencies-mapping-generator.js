const glob = require('glob-promise');
const path = require('path');

const KopytkoError = require('@kopytko/packager/src/errors/kopytko-error');
const FileHandler = require('@kopytko/packager/src/plugin-helpers/file-handler');

const UnitTestingBrightscriptDependencies = require('./brightscript/unit-testing-brightscript-dependencies');

const BRIGHTSCRIPT_FILE_EXTENSION = '.brs';
const BRIGHTSCRIPT_FILE_PATH_PATTERN = '/components/**/*.brs';
const BRIGHTSCRIPT_LOCAL_DEPENDENCY_PREFIX = 'pkg:';
const BRIGHTSCRIPT_MOCK_FILE_EXTENSION = '.mock.brs';

module.exports = class DependenciesMappingGenerator {
  async generate(dir) {
    const brsFilePaths = await glob(path.join(dir, BRIGHTSCRIPT_FILE_PATH_PATTERN), {});
    const filesImportPaths = await Promise.all(
      brsFilePaths.map(async filePath => (await this._getBrightscriptDependencies(filePath)).getImportPaths()),
    );
    const filesMockPaths = await Promise.all(
      brsFilePaths.map(async filePath => (await this._getBrightscriptDependencies(filePath)).getMockPaths()),
    );
    const mapping = {};

    brsFilePaths
      .map(path => path.replace(dir, BRIGHTSCRIPT_LOCAL_DEPENDENCY_PREFIX))
      .forEach((brsFileUri, index) => {
        const fileImportPaths = filesImportPaths[index];
        const fileMockPaths = filesMockPaths[index];

        this._checkCircularDependency(mapping, fileImportPaths, brsFileUri);

        mapping[brsFileUri] = {
          dependencies: fileImportPaths,
          mocks: fileMockPaths
            .map((path) => path.replace(BRIGHTSCRIPT_FILE_EXTENSION, BRIGHTSCRIPT_MOCK_FILE_EXTENSION)),
        };
      });

    return mapping;
  }

  async _getBrightscriptDependencies(filePath) {
    const fileLines = await FileHandler.readLines(filePath);

    return new UnitTestingBrightscriptDependencies(fileLines, filePath);
  }

  _checkCircularDependency(mapping, fileImportPaths, fileUri) {
    if (fileImportPaths.length) {
      const circularDependency = fileImportPaths
        .find(importPath => mapping[importPath] && mapping[importPath].dependencies.includes(fileUri));

      if (circularDependency) {
        throw new KopytkoError(`Circular dependencies found: ${fileUri} and ${circularDependency}!`);
      }
    }
  }
}
