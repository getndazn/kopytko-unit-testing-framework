const INDENTATION = '  ';
const MEMBER_SEPARATOR = ',\n';

module.exports = class MockContentGeneratorUtils {
  static formatParams(functionInfo) {
    return functionInfo.params.map(param => `${param}: ${param}`);
  }

  static joinMembers(members, indentationLevel) {
    return members.join(`${MEMBER_SEPARATOR}${INDENTATION.repeat(indentationLevel)}`);
  }
}
