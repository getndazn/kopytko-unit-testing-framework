const glob = require('glob-promise');
const path = require('path');

const FileHandler = require('@kopytko/packager/src/plugin-helpers/file-handler');
const XmlDependencies = require('@kopytko/packager/src/plugin-helpers/xml/xml-dependencies');
const DependenciesFinder = require('./helpers/dependencies-finder');
const DependenciesImporter = require('./helpers/dependencies-importer');
const DependenciesMappingGenerator = require('./helpers/dependencies-mapping-generator');

const XML_FILE_PATH_PATTERN = '/components/**/*.xml';

module.exports = async function importDependencies(dir) {
  const dependenciesImporter = await createDependenciesImporter(dir);

  return updateXmlFiles(dir, dependenciesImporter);
}

async function updateXmlFiles(dir, dependenciesImporter) {
  const xmlFilePaths = await glob(path.join(dir, XML_FILE_PATH_PATTERN));

  return Promise.all(
    xmlFilePaths.map(filePath => updateXmlFile(filePath, dir, dependenciesImporter))
  );
}

async function updateXmlFile(filePath, dir, dependenciesImporter) {
  const fileLines = await FileHandler.readLines(filePath);
  const xmlDependencies = new XmlDependencies(fileLines, filePath, dir);
  const dependencyPaths = xmlDependencies.getDependencyPaths();
  const dependencyPathsToAdd = dependenciesImporter.import(dependencyPaths);

  if (dependencyPathsToAdd.length > 0) {
    const updatedFileLines = xmlDependencies.updateFileDependencies(dependencyPathsToAdd);

    await FileHandler.writeLines(filePath, updatedFileLines);
  }
}

async function createDependenciesImporter(dir) {
  const mapping = await new DependenciesMappingGenerator().generate(dir);
  const finder = new DependenciesFinder(mapping);

  return new DependenciesImporter(finder, mapping);
}