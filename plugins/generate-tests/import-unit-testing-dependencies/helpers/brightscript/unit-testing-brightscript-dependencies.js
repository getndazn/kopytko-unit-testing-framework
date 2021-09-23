const BrightscriptDependencies = require('@dazn/kopytko-packager/src/plugin-helpers/brightscript/brightscript-dependencies');
const BrightscriptExternalDependencyItemCreator = require('@dazn/kopytko-packager/src/plugin-helpers/brightscript/brightscript-external-dependency-item-creator');
const BrightscriptInternalDependencyItemCreator = require('@dazn/kopytko-packager/src/plugin-helpers/brightscript/brightscript-internal-dependency-item-creator');

const BrightscriptExternalMockFinder = require('./brightscript-external-mock-finder');
const BrightscriptInternalMockFinder = require('./brightscript-internal-mock-finder');


module.exports = class UnitTestingBrightscriptDependencies extends BrightscriptDependencies {
  _mockDependencyCollection;

  /**
   * Reads file lines and saves dependencies
   * @param {Array<String>} fileLines
   * @param {String} filePath
   * @param {Modules} modules
   * @param {String} [rootDir]
   */
  constructor(fileLines, filePath, modules, rootDir = '') {
    super(fileLines, filePath, modules, rootDir);

    const internalItemCreator = new BrightscriptInternalDependencyItemCreator(this._rootDir, this._modulePrefix, filePath);
    this._mockDependencyCollection = this.getDependencyCollection(new BrightscriptInternalMockFinder(internalItemCreator));

    const externalItemCreator = new BrightscriptExternalDependencyItemCreator(this._rootDir, this._modulePrefix, filePath, modules);
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
