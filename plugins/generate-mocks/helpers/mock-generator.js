const FileHandler = require('@kopytko/packager/src/plugin-helpers/file-handler');
const FunctionInfo = require('./function-info');
const FunctionType = require('./function-type.const');
const FunctionMockContentGenerator = require('./function-mock-content-generator');
const ObjectMockContentGenerator = require('./object-mock-content-generator');

const BRIGHTSCRIPT_FILE_EXTENSION = '.brs';
const BRIGHTSCRIPT_MOCK_CONFIG_FILE_EXTENSION = '.config.brs';
const BRIGHTSCRIPT_MOCK_FILE_EXTENSION = '.mock.brs';
const MANUAL_MOCKS_DIRECTORY = '_mocks';

module.exports = class MockGenerator {
  constructor() {
    this._functionMockContentGenerator = new FunctionMockContentGenerator();
    this._objectMockContentGenerator = new ObjectMockContentGenerator();
  }

  async generate(dependency) {
    const manualMockPath = this._getManualMockPath(dependency);
    let content = FileHandler.exists(manualMockPath)
      ? await FileHandler.read(manualMockPath)
      : await this._generateMockContent(dependency);

    const mockConfigPath = this._getMockConfigPath(dependency);
    if (FileHandler.exists(mockConfigPath)) {
      const mockConfigContent = await FileHandler.read(mockConfigPath);
      content = `${content}${FileHandler.NEW_LINE_CHAR}${FileHandler.NEW_LINE_CHAR}${mockConfigContent}`;
    }

    await FileHandler.write(dependency.replace(BRIGHTSCRIPT_FILE_EXTENSION, BRIGHTSCRIPT_MOCK_FILE_EXTENSION), content);
  }

  async _generateMockContent(dependency) {
    // @todo ROKU-780 analyze inheritance
    const fileLines = await FileHandler.readLines(dependency);
    const fileFunctionInfo = this._createFileFunctionInfo(fileLines);

    if (!fileFunctionInfo) {
      return null;
    }

    if (!fileFunctionInfo.isConstructor()) {
      return this._functionMockContentGenerator.generate({ function: fileFunctionInfo });
    }

    return this._objectMockContentGenerator.generate({
      constructor: fileFunctionInfo,
      methods: this._createMethodsInfo(fileLines),
    });
  }

  _getManualMockPath(dependency) {
    const dependencyName = this._getDependencyName(dependency);
    const mockName = dependencyName.replace(BRIGHTSCRIPT_FILE_EXTENSION, BRIGHTSCRIPT_MOCK_FILE_EXTENSION);

    return dependency.replace(dependencyName, `${MANUAL_MOCKS_DIRECTORY}/${mockName}`);
  }

  _getMockConfigPath(dependency) {
    const dependencyName = this._getDependencyName(dependency);
    const configFileName = dependencyName.replace(BRIGHTSCRIPT_FILE_EXTENSION, BRIGHTSCRIPT_MOCK_CONFIG_FILE_EXTENSION);

    return dependency.replace(dependencyName, `${MANUAL_MOCKS_DIRECTORY}/${configFileName}`);
  }

  _getDependencyName(dependency) {
    const dependencyPathParts = dependency.split('/');

    return dependencyPathParts[dependencyPathParts.length - 1];
  }

  _createFileFunctionInfo(fileLines) {
    let functionInfo;
    fileLines.find((line) => {
      functionInfo = FunctionInfo.parse(line);

      return functionInfo;
    });

    return functionInfo;
  }

  _createMethodsInfo(fileLines) {
    return fileLines.reduce((methods, line) => {
      const methodInfo = FunctionInfo.parse(line, FunctionType.METHOD);

      if (methodInfo) {
        methods.push(methodInfo);
      }

      return methods;
    }, []);
  }
}
