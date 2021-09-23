const DependencyFinder = require('@dazn/kopytko-packager/src/plugin-helpers/dependency/dependency-finder');

const BRIGHTSCRIPT_MOCK_REGEX = /^\s*'\s*@mock\s+(?:pkg:)?(\/[\w-/.]+\.brs)\s*$/;

module.exports = class BrightscriptInternalMockFinder extends DependencyFinder {
  /**
   * Creates a finder for dependencies imported with @mock annotation.
   * @param {BrightscriptDependencyItemCreator} dependencyItemCreator
   */
  constructor(mockItemCreator) {
    super(BRIGHTSCRIPT_MOCK_REGEX, mockItemCreator);
  }
}
