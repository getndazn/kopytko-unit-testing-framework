module.exports = class ScriptTestContentGenerator {
  generate(data) {
    return `<?xml version="1.0" encoding="utf-8" ?>

<component
  name="Test__${data.testName}"
  extends="Node"
  xsi:noNamespaceSchemaLocation="https://devtools.web.roku.com/schema/RokuSceneGraph.xsd"
>
  <interface>
    <function name="TestFramework__RunNodeTests" />
  </interface>

  <!-- Tested file -->
  <script type="text/brightscript" uri="${data.unitPath}" />

  <!-- Test suites -->
${data.testSuiteDependencies}

  <script type="text/brightscript">
  <![CDATA[
    sub init()
      runner = TestRunner()
      runner.setFunctions([
${data.testSuiteNames}
      ])
    end sub
  ]]>
  </script>
</component>`;
  }
}
