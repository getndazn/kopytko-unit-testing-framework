const fs = require('fs-extra');
const args = require('../../../../packager-steps/args');

function _buildContent() {
  const testsFilter = args.tests
    ? args.tests.split(';').map((t) => `"Test__${t.trim()}_"`).join(', ')
    : '';
  const setTestsFilterLine = testsFilter
    ? `\n  runner.setTestsFilter([${testsFilter}])`
    : '';

  return `sub main()
  screen = CreateObject("roSGScreen")
  port = CreateObject("roMessagePort")
  screen.setMessagePort(port)
  screen.show()

  scene = screen.createScene("UnitTestingScene")
  verbosity = CreateObject("roAppInfo").getValue("testRunnerVerbosity").toInt()

  runner = TestRunner()
  runner.logger.setVerbosity(verbosity)
  runner.setTestFilePrefix("Test__${args.testFileName || ''}")${setTestsFilterLine}
  runner.run()
end sub`;
}

module.exports = class TestMainFileContentGenerator {
  static async generate(location) {
    await fs.outputFile(location, _buildContent());
  }
}
