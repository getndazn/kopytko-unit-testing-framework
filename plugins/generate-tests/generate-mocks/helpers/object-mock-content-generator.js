const Utils = require('./mock-content-generator-utils');

const CONSTRUCTOR_PARAMS_INDENTATION_LEVEL = 3;
const METHOD_INDENTATION_LEVEL = 3;
const METHOD_PARAMS_INDENTATION_LEVEL = 5;

module.exports = class ObjectMockContentGenerator {
  generate(mockInfo) {
    return `' @import /components/_mocks/Mock.brs from @kopytko/unit-testing-framework
function ${mockInfo.constructor.name}(${mockInfo.constructor.rawParams}) as Dynamic
  return Mock({
    testComponent: m,
    name: "${mockInfo.constructor.name}",
    methods: {
      ${this._generateMethods(mockInfo.methods)}
    },
    constructorParams: {
      ${this._formatParams(mockInfo.constructor, CONSTRUCTOR_PARAMS_INDENTATION_LEVEL)}
    },
  })
end function`;
  }

  _generateMethods(methodsInfo) {
    const methods = methodsInfo.map(method => `${method.name}: function (${method.rawParams}) as Dynamic
        return m.${method.name}Mock("${method.name}", {
          ${this._formatParams(method, METHOD_PARAMS_INDENTATION_LEVEL)}
        }${this._formatReturnType(method)})
      end function`);

    return Utils.joinMembers(methods, METHOD_INDENTATION_LEVEL);
  }

  _formatParams(methodInfo, indentationLevel) {
    const params = Utils.formatParams(methodInfo);

    return Utils.joinMembers(params, indentationLevel);
  }

  _formatReturnType(methodInfo) {
    return methodInfo.returnType ? `, "${methodInfo.returnType}"` : '';
  }
}
