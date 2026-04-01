const fs = require('fs').promises;
const { glob } = require('glob');
const { randomUUID } = require('crypto');

const args = require('../../../packager-steps/args');
const TestSceneGenerator = require('./helpers/test-scene-generator');
const TestMainFileContentGenerator = require('./helpers/test-main-file-content-generator');
const TestSchema = require('./helpers/test-schema');
const TestXmlGenerator = require('./helpers/test-xml-generator');

const IGNORED_TEST_FILES_PATH_PATTERN = '/components/**/_tests/**/*_*.brs';
const MAIN_FILE_LOCATION = '/source/Main.brs';
const TEST_FILE_NAME_REGEX = /[^/]+(?=\.test\.brs)/;
const TEST_FILES_PATH_PATTERN = '/components/**/_tests/**/*.test.brs';
const TESTS_LOCATION = '/components/tests/auto-generated/';

module.exports = async function prepareTestSchema(dir) {
  let testFilePaths = await glob(`${dir}${TEST_FILES_PATH_PATTERN}`, {
    ignore: `${dir}${IGNORED_TEST_FILES_PATH_PATTERN}`,
  });

  if (args.tests) {
    const patterns = args.tests.split(';').map((pattern) => pattern.trim()).filter(Boolean);
    testFilePaths = testFilePaths.filter((filePath) => {
      const unitName = filePath.match(TEST_FILE_NAME_REGEX)?.[0];

      return unitName && patterns.some((pattern) => _matchesPattern(unitName, pattern));
    });
    console.log(`[generate-tests] --tests filter: ${patterns.join(', ')} → ${testFilePaths.length} test file(s)`);
  }

  const testXmlGenerator = new TestXmlGenerator(dir);

  await TestSceneGenerator.generate(`${dir}${TESTS_LOCATION}`);
  await TestMainFileContentGenerator.generate(`${dir}${MAIN_FILE_LOCATION}`)
  await Promise.all(
    testFilePaths.map(filePath => prepareSchema(filePath, testXmlGenerator, dir)),
  );
}

function _matchesPattern(str, pattern) {
  const regex = new RegExp(
    '^' + pattern.replace(/[.+^${}()|[\]\\]/g, '\\$&').replace(/\*/g, '.*').replace(/\?/g, '.') + '$',
    'i',
  );

  return regex.test(str);
}

async function prepareSchema(testFilePath, testXmlGenerator, rootDir) {
  const testSchema = await TestSchema.load(testFilePath);
  if (!testSchema) {
    return;
  }

  const outputLocation = `${rootDir}${TESTS_LOCATION}/${testSchema.unit.name}/${randomUUID()}/`;

  await fs.mkdir(outputLocation, { recursive: true });

  await Promise.all(
    testSchema.testSuites.map(testSuite => copyTestSuite(testSuite, outputLocation)),
  );

  await testXmlGenerator.generate(testSchema, outputLocation);
}

function copyTestSuite(testSuite, outputLocation) {
  return fs.copyFile(testSuite.filePath, `${outputLocation}${testSuite.outputFileName}`);
}
