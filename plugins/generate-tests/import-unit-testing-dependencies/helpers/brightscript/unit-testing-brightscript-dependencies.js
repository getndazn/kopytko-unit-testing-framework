const BrightscriptDependencies = require('@kopytko/packager/src/plugin-helpers/brightscript/brightscript-dependencies');
const BrightscriptExternalDependencyItemCreator = require('@kopytko/packager/src/plugin-helpers/brightscript/brightscript-external-dependency-item-creator');
const BrightscriptInternalDependencyItemCreator = require('@kopytko/packager/src/plugin-helpers/brightscript/brightscript-internal-dependency-item-creator');

const BrightscriptExternalMockFinder = require('./brightscript-external-mock-finder');
const BrightscriptInternalMockFinder = require('./brightscript-internal-mock-finder');


module.exports = class UnitTestingBrightscriptDependencies extends BrightscriptDependencies {
  _mockDependencyCollection;

  /**
   * Reads file lines and saves dependencies
   * @param {Array<String>} fileLines
   * @param {String} filePath
   * @param {String} [rootDir]
   */
  constructor(fileLines, filePath, rootDir = '') {
    super(fileLines, filePath, rootDir);

    const internalItemCreator = new BrightscriptInternalDependencyItemCreator(this._rootDir, this._sanitizedModuleName);
    this._mockDependencyCollection = this.getDependencyCollection(new BrightscriptInternalMockFinder(internalItemCreator));

    const externalItemCreator = new BrightscriptExternalDependencyItemCreator(this._rootDir);
    const externalMockDependencyCollection = this.getDependencyCollection(new BrightscriptExternalMockFinder(externalItemCreator));
    externalMockDependencyCollection.getItems().forEach(dependency => this._mockDependencyCollection.add(dependency));
  }

  /**
   * Returns the paths of mocks defined after the "@mock" annotation.
   * @returns {Array<String>}
   */
  getMockPaths() {
    return this._mockDependencyCollection.getPaths();
  }
}
