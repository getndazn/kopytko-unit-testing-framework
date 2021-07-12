const generateDependencyIdentifier = require('./generate-dependency-identifier');
const sortUris = require('./sort-uris');

module.exports = class DependenciesImporter {
  _finder;
  _mapping;

  constructor(finder, mapping) {
    this._finder = finder;
    this._mapping = mapping;
  }

  import(dependencyPaths) {
    const dependencyPathsToAdd = this._findSubDependenciesToAdd(dependencyPaths);

    if (dependencyPathsToAdd.length) {
      sortUris(dependencyPathsToAdd);
    }

    return dependencyPathsToAdd;
  }

  _findSubDependenciesToAdd(dependencies) {
    const mocksMapping = this._generateMocksMapping(dependencies);

    const subDependencies = dependencies.reduce((allSubDependencies, dependency) => {
      return allSubDependencies.concat(this._finder.find(dependency, mocksMapping));
    }, []);
    subDependencies.push(...Object.values(mocksMapping));

    return [...new Set(subDependencies)].filter(subDependency => !dependencies.includes(subDependency));
  }

  _generateMocksMapping(dependencies) {
    const mocksMapping = {};

    dependencies.forEach(dependency => {
      const mocks = this._mapping[dependency] && this._mapping[dependency].mocks || [];

      mocks.forEach(mock => mocksMapping[generateDependencyIdentifier(mock)] = mock);
    });

    return mocksMapping;
  }
}
