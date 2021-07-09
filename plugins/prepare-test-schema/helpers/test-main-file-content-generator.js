const args = require('@kopytko/packager/src/env/args');
const fs = require('fs').promises;

const CONTENT = `sub main()
  screen = CreateObject("roSGScreen")
  port = CreateObject("roMessagePort")
  screen.setMessagePort(port)
  screen.show()

  scene = screen.createScene("TestScene")
  verbosity = CreateObject("roAppInfo").getValue("testRunnerVerbosity").toInt()

  runner = TestRunner()
  runner.logger.setVerbosity(verbosity)
  runner.setTestFilePrefix("Test__${args.testFileName || ''}")
  runner.run()
end sub`;

module.exports = class TestMainFileContentGenerator {
  static async generate(location) {
    await fs.writeFile(location, CONTENT);
  }
}
