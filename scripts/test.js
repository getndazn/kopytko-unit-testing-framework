const StepRunner = require('@dazn/kopytko-packager/src/step-runner/step-runner');
const validateArgs = require('@dazn/kopytko-packager/src/env/validate-args');
const BuildStep = require('@dazn/kopytko-packager/src/step-runner/steps/build/build-step');
const buildStepConfig = require('@dazn/kopytko-packager/src/step-runner/steps/build/build-step-config');
const DeployStep = require('@dazn/kopytko-packager/src/step-runner/steps/deploy/deploy-step');
const deployStepConfig = require('@dazn/kopytko-packager/src/step-runner/steps/deploy/deploy-step-config');

const VerifyTestsResultStep = require('../packager-steps/verify-tests-result/verify-tests-result-step');
const verifyTestsResultStepConfig = require('../packager-steps/verify-tests-result/verify-tests-result-step-config');

(async () => {
  await validateArgs();

  await new StepRunner([
    { step: BuildStep, config: buildStepConfig },
    { step: DeployStep, config: deployStepConfig },
    { step: VerifyTestsResultStep, config: verifyTestsResultStepConfig },
  ]).run();
})();
