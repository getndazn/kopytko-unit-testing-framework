const generateDependencyIdentifier = require('./generate-dependency-identifier');

module.exports = class DependenciesFinder {
  constructor(mapping) {
    this._mapping = mapping;
  }

  find(filePath, mocksMapping) {
    if (!this._mapping[filePath]) {
      return [];
    }

    const fileDependencies = this._findAllDependencies(filePath, mocksMapping);

    return [...new Set(fileDependencies)];
  }

  _findAllDependencies(filePath, mocksMapping) {
    const allDependencies = [];
    const dependenciesToCheck = this._getSubDependencies(filePath);
    let dependencyIndex = 0;

    while (dependencyIndex < dependenciesToCheck.length) {
      let dependency = dependenciesToCheck[dependencyIndex];
      const mock = this._findMock(dependency, mocksMapping);

      if (mock) {
        dependency = mock;
      }

      allDependencies.push(dependency);

      if (this._mapping[dependency]) {
        const subDependencies = this._getSubDependencies(dependency);
        dependenciesToCheck.push(...subDependencies);
      }

      dependencyIndex++;
    }

    return allDependencies;
  }

  _getSubDependencies(dependency) {
    const dependencies = this._mapping[dependency].dependencies || [];
    const mocks = this._mapping[dependency].mocks || [];

    return dependencies.concat(mocks);
  }

  _findMock(dependency, mocksMapping) {
    const dependencyIdentifier = generateDependencyIdentifier(dependency);

    return mocksMapping[dependencyIdentifier];
  }
}
