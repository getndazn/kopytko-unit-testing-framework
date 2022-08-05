const baseManifest = require('@dazn/kopytko-packager/base-manifest');

module.exports = {
  ...baseManifest,
  bs_const: {
    insertKopytkoUnitTestSuiteArgument: true,
  },
  testRunnerVerbosity: 2,
  title: 'Kopytko Unit Testing Framework App',
  ui_resolutions: 'fhd',
}
