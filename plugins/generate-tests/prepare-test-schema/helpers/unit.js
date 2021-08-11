const NODE_EXTENSION = 'xml';

module.exports = class Unit {
  constructor(name, filePath, fileName) {
    this.name = name;
    this.filePath = filePath;
    this.fileLocation = filePath.split(fileName)[0];
    this.isNode = filePath.endsWith(NODE_EXTENSION);
  }
}
