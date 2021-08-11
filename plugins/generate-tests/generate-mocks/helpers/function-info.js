const FunctionType = require('./function-type.const');

const FUNCTION_REGEX = /(function|sub) (?<name>[^_]\S+) ?[(](?<params>.*)[)]( as (?<returnType>\S+))?/;
const METHOD_REGEX = /\S+[.](?<name>[^_]\S+) ?[=] ?(function|sub) ?[(](?<params>.*)[)]( as (?<returnType>\S+))?/;

const PARAM_SEPARATOR = ',';
const PARAM_TYPE_SEPARATOR = ' ';

module.exports = class FunctionInfo {
  static parse(rawText, type = FunctionType.COMPONENT) {
    const match = rawText.match(type === FunctionType.METHOD ? METHOD_REGEX : FUNCTION_REGEX);

    return match ? new FunctionInfo(match.groups) : null;
  }

  constructor({ name, params, returnType }) {
    this.name = name;
    this.rawParams = params;
    this.returnType = returnType || '';

    if (params.length) {
      this.params = params
        .split(PARAM_SEPARATOR)
        .map(param => param.trim().split(PARAM_TYPE_SEPARATOR)[0]);
    } else {
      this.params = [];
    }
  }

  isConstructor() {
    // constructor should start with capital letter
    return this.name.match(/^[A-Z]/);
  }
}
