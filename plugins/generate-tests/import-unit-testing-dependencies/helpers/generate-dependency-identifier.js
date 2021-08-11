const FILE_NAME_REGEX = /[^/]+.brs/;

module.exports = function generateDependencyIdentifier(dependency) {
  return dependency.match(FILE_NAME_REGEX)[0]
    .replace(/[.]|mock|brs/g, '')
    .toLowerCase();
}
