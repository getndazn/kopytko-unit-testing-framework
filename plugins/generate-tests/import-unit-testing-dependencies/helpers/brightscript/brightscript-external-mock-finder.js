const DependencyFinder = require('@dazn/kopytko-packager/src/plugin-helpers/dependency/dependency-finder');

const BRIGHTSCRIPT_EXTERNAL_MOCK_REGEX = /^\s*'\s*@mock\s+(?:pkg:)?((\/[\w-/.]+\.brs)\s+from\s+([\w-/.@!]+))\s*$/;

module.exports = class BrightscriptExternalMockFinder extends DependencyFinder {
  /**
   * Creates a finder for external dependencies imported with @mock annotation.
   * @param {BrightscriptDependencyItemCreator} dependencyItemCreator
   */
  constructor(mockItemCreator) {
    super(BRIGHTSCRIPT_EXTERNAL_MOCK_REGEX, mockItemCreator);
  }
}
