const MockGenerator = require('./helpers/mock-generator');
const MockedDependenciesFinder = require('./helpers/mocked-dependencies-finder');

module.exports = async function generateMocks(rootDir) {
  const mockedDependencies = await new MockedDependenciesFinder(rootDir).find();
  const mockGenerator = new MockGenerator();

  await Promise.all(mockedDependencies.map(dependency => mockGenerator.generate(dependency)));
}
