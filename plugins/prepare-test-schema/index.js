const fs = require('fs').promises;
const glob = require('glob-promise');
const uuid = require('uuid').v4;

const TestSceneGenerator = require('./helpers/test-scene-generator');
const TestMainFileContentGenerator = require('./helpers/test-main-file-content-generator');
const TestSchema = require('./helpers/test-schema');
const TestXmlGenerator = require('./helpers/test-xml-generator');

const IGNORED_TEST_FILES_PATH_PATTERN = '/components/**/_tests/**/*_*.brs';
const MAIN_FILE_LOCATION = '/source/Main.brs';
const TEST_FILES_PATH_PATTERN = '/components/**/_tests/**/*.test.brs';
const TESTS_LOCATION = '/components/tests/auto-generated/';

module.exports = async function prepareTestSchema(dir) {
  const testFilePaths = await glob(`${dir}${TEST_FILES_PATH_PATTERN}`, {
    ignore: `${dir}${IGNORED_TEST_FILES_PATH_PATTERN}`,
  });
  const testXmlGenerator = new TestXmlGenerator(dir);

  await TestSceneGenerator.generate(`${dir}${TESTS_LOCATION}`);
  await TestMainFileContentGenerator.generate(`${dir}${MAIN_FILE_LOCATION}`)
  await Promise.all(
    testFilePaths.map(filePath => prepareSchema(filePath, testXmlGenerator, dir))
  );
}

async function prepareSchema(testFilePath, testXmlGenerator, rootDir) {
  const testSchema = await TestSchema.load(testFilePath);
  if (!testSchema) {
    return;
  }

  const outputLocation = `${rootDir}${TESTS_LOCATION}/${testSchema.unit.name}/${uuid()}/`;

  await fs.mkdir(outputLocation, { recursive: true });

  testSchema.testSuites.forEach(testSuite => {
    fs.copyFile(testSuite.filePath, `${outputLocation}${testSuite.outputFileName}`);
  });

  await testXmlGenerator.generate(testSchema, outputLocation);
}
