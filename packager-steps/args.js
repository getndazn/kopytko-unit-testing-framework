const args = require('@dazn/kopytko-packager/src/env/args');

const firstArgument = process.argv[2] || '';
const anonymousArgument = !firstArgument.includes('--') ? firstArgument : '';
const testFileName = process.env.ENV === 'test' ? anonymousArgument : '';

/**
 * @type {string} Unit test file/suite name.
 *
 * TEST_FILE_NAME=AppView
 *
 * TEST_FILE_NAME=AppView npm test
 * npm test -- --testFileName=AppView
 */
args.testFileName = testFileName || process.env.TEST_FILE_NAME || '';

module.exports = args;
