const buildModules = require('@dazn/kopytko-packager/src/plugin-helpers/module/build-modules');

const generateMocks = require('./generate-mocks');
const prepareTestSchema = require('./prepare-test-schema');
const importDependencies = require('./import-unit-testing-dependencies');

module.exports = async function generateTests(rootDir) {
  const modules = buildModules();

  await generateMocks(rootDir, modules);
  await prepareTestSchema(rootDir);
  await importDependencies(rootDir, modules);
}
