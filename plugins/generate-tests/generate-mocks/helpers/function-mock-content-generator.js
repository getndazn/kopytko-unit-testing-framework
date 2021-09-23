const Utils = require('./mock-content-generator-utils');

const FUNCTION_PARAMS_INDENTATION_LEVEL = 3;

module.exports = class FunctionMockContentGenerator {
  generate(mockInfo) {
    return `' @import /components/_mocks/Mock.brs from @dazn/kopytko-unit-testing-framework
function ${mockInfo.function.name}(${mockInfo.function.rawParams}) as Dynamic
  return Mock({
    name: "${mockInfo.function.name}",
    params: {
      ${this._formatParams(mockInfo.function)}
    },
    returnValueType: "${mockInfo.function.returnType}",
  })
end function`;
  }

  _formatParams(functionInfo) {
    const params = Utils.formatParams(functionInfo);

    return Utils.joinMembers(params, FUNCTION_PARAMS_INDENTATION_LEVEL);
  }
}
