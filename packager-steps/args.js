const args = require('@dazn/kopytko-packager/src/env/args');
const { parse } = require('path');

const { name: scriptName } = parse(process.argv[1]);

/**
 * @type {string} Unit test file/suite name.
 *
 * support below shortcuts
 * TEST_FILE_NAME=AppView npm test
 * npm test -- --testFileName=AppView
 * npm test -- AppView
 * node node_modules/@dazn/kopytko-unit-testing-framework/scripts/test.js AppView
 * node someScript.js test AppView
 */

if (args.env === 'test' && ((scriptName === 'test' && args._.length) || args._.length > 1)) {
  args.testFileName = args._.slice(-1)[0];
}

/**
 * @type {string} Semicolon-separated list of glob patterns to filter which test files are built and run.
 * Supports * and ? wildcards. Matched against the unit name (filename without .test.brs).
 * Takes precedence over --testFileName when provided.
 *
 * npm test -- --tests=Rail*;Video*;Tile*
 * npm test -- --tests=RailsService;Tile
 * TESTS=Rail*;Video* npm test
 */

if (!args.tests && process.env.TESTS) {
  args.tests = process.env.TESTS;
}

module.exports = args;
