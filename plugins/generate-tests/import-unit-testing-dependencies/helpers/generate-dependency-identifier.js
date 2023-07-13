const getModulePrefixByFilePath = require('@dazn/kopytko-packager/src/plugin-helpers/module/get-module-prefix-by-file-path');

const FILE_NAME_REGEX = /[^/]+.brs/;

module.exports = function generateDependencyIdentifier(dependency) {
  const fileIdentifier = dependency.match(FILE_NAME_REGEX)[0]
    .replace(/[.]|mock|brs/g, '')
    .toLowerCase();
  const modulePrefix = getModulePrefixByFilePath(dependency);

  return modulePrefix ? `${modulePrefix}/${fileIdentifier}` : fileIdentifier;
}
