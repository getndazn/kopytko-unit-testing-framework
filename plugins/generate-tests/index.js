const generateMocks = require('./generate-mocks');
const prepareTestSchema = require('./prepare-test-schema');
const importDependencies = require('./import-unit-testing-dependencies');

module.exports = async function generateTests(rootDir) {
  await generateMocks(rootDir);
  await prepareTestSchema(rootDir);
  await importDependencies(rootDir);
}
