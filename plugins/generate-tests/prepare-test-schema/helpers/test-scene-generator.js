const fs = require('fs').promises;

const CONTENT =
`<?xml version="1.0" encoding="utf-8" ?>
<component name="UnitTestingScene" extends="Scene">
  <children>
    <Label
      id="message"
      text="Unit tests are running..."
      translation="[660, 540]"
      horizAlign="center"
      width="600"
    />
  </children>
</component>`;

module.exports = class TestSceneGenerator {
  static async generate(location) {
    await fs.mkdir(location, { recursive: true });
    await fs.writeFile(`${location}UnitTestingScene.xml`, CONTENT);
  }
}
