const fs = require('fs').promises;

const NodeTestContentGenerator = require('./node-test-content-generator');
const ScriptTestContentGenerator = require('./script-test-content-generator');

const NEW_LINE_CHAR = '\n';
const PACKAGE_PATH_PREFIX = 'pkg:';

module.exports = class TestXmlGenerator {
  constructor(rootDir) {
    this._rootDir = rootDir;
  }

  async generate(test, location) {
    const content = this._generateContent(test);
    const outputPath = `${location}Test__${test.name}.xml`;

    await fs.writeFile(outputPath, content);
  }

  _generateContent(test) {
    const generator = test.unit.isNode
      ? new NodeTestContentGenerator()
      : new ScriptTestContentGenerator();

    return generator.generate({
      testName: test.name,
      unitName: test.unit.name,
      unitPath: this._buildPackagePath(test.unit.filePath),
      testSuiteNames: this._generateTestSuiteNames(test),
      testSuiteDependencies: test.testSuites.map(this._buildTestSuiteDependencyLine).join(NEW_LINE_CHAR),
    });
  }

  _generateTestSuiteNames(test) {
    const excludeMain = test.testSuites.length !== 1;

    return test.testSuites
      .filter(testSuite => !excludeMain || !testSuite.isMain)
      .map(this._buildTestSuiteNameLine)
      .join(NEW_LINE_CHAR);
  }

  _buildTestSuiteNameLine(testSuite) {
    return `        TestSuite__${testSuite.name},`;
  }

  _buildTestSuiteDependencyLine(testSuite) {
    return `  <script type="text/brightscript" uri="${testSuite.outputFileName}" />`;
  }

  _buildPackagePath(filePath) {
    return filePath.replace(this._rootDir, PACKAGE_PATH_PREFIX);
  }
}
