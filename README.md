# Kopytko Unit Testing Framework

- [App Structure](#app-structure)
- [Setup](#setup)
- [Running Unit Tests](#running-unit-tests)
- [Kopytko Unit Test Philosophy](#kopytko-unit-test-philosophy)
- [Test Mocks](#test-mocks)
- [Setup and Teardown](#setup-and-teardown)
- [Limitations](#limitations)
- [API](#api)
- [Example test app config and unit tests](#example-test-app-config-and-unit-tests)
- [Migration from v1 to v2](#migration-from-v1-to-v2)

The unit testing framework works on top of the [Roku Unit Testing framework](https://github.com/rokudev/unit-testing-framework). There are some differences between those two frameworks.

## App Structure

We believe tests should be close to the tested objects.

The expected structure of the app:

```
 components
  _mocks
    MyService.mock.brs
  _tests
    MyComponent.test.brs
  MyComponent.brs
  MyComponent.xml
  MyService.brs
```

The `_tests` folders should be placed near to the tested entity. Each test suite gains extra powers:

- no need for xml files
- no need to define test suites functions in an array
- ability to import dependencies
- ability to mock dependencies automatically
- ability to mock dependencies manually

## Setup

1. Install framework as a dev dependency
```shell
npm install @dazn/kopytko-unit-testing-framework --save-dev
```

2. Kopytko Unit Testing Framework uses [Kopytko Packager](https://github.com/getndazn/kopytko-packager) to build apps.
   If you don't use it yet, go to its docs and init a @kopytko app. Once done, setup test environment in your `.kopytkorc` file
```json
{
  "pluginDefinitions": {
    "generate-tests": "/node_modules/@dazn/kopytko-unit-testing-framework/plugins/generate-tests"
  },
  "plugins": [
    { "name": "kopytko-copy-external-dependencies", "preEnvironmentPlugin": true }
  ],
  "environments": {
    "test": {
      "plugins": ["generate-tests"]
    }
  }
}
```
Remark: You can use any name for the test environment, just be consistent.

3. Setup test script in your `package.json`
```json
{
  "scripts": {
    "test": "ENV=test node ../scripts/test.js"
  }
}
```

4. \[Temporary\] To not force [migration from v1 to v2](#migration-from-v1-to-v2) to be imidiate we introduced a bs_const flag (details in Migration part). The flag will be temporary for the depreciation period. In your manifest file please add bs_const:
```js
{
  bs_const: {
    insertKopytkoUnitTestSuiteArgument: false,
  }
}
```

## Running Unit Tests

Simply
```shell
npm test
```

If you want to run unit tests of a specific unit, you can pass the file name as a default argument:
```shell
npm test -- MyTestableUnit
```
This is a shortcut for `npm test -- --testFileName=MyTestableUnit`

## Kopytko Unit Test Philosophy

The unit tests can be split into multiple files and imported by the packager automatically. Let's consider the following example:
```
 components
  _tests
    MyService_getData.test.brs
    MyService_Main.test.brs
    MyServiceTestSuite.test.brs
  MyService.brs
```
`MyService.brs`
```brightscript
function MyService() as Object
  prototype = {}

  prototype.getData = function (arg as String) as Object
    return { arg: arg }
  end function

  return prototype
end function
```
`MyServiceTestSuite.test.brs`
```brightscript
' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
function MyServiceTestSuite() as Object
  ts = KopytkoTestSuite()

  beforeAll(sub (_ts as Object)
    ' do something
  end sub)

  return ts
end function
```
`MyService_Main.test.brs`
```brightscript
function TestSuite__MyService_Main() as Object
  ts = MyServiceTestSuite()
  ts.name = "MyService - Main"

  it("should create new instance of the service", function (_ts as Object) as String
    return expect(MyService()).toBeValid()
  end function)

  return ts
end function
```
`MyService_getData.test.brs`
```brightscript
function TestSuite__MyService_getData() as Object
  ts = MyServiceTestSuite()
  ts.name = "MyService - getData"

  it("should return some data", function (_ts as Object) as String
   ' Given
    service = MyService()
    expected = { arg: "abc" }

    ' When
    result = service.getData("abc")

    'Then
    return expect(result).toEqual(expected)
  end function)

  return ts
end function
```
Such structure is understood and imported automatically by the packager.

Behind the scenes Kopytko Unit Testing Framework replaces the source/Main.brs file to run unit tests.
Roku's Unit Testing Framework core file is automatically imported by Kopytko Packager via ROPM.

## Test Mocks

Dependencies may be mocked by using `@mock` annotation after dependencies import in the main test file:

`' @mock pkg:/components/example/ExampleService.brs`

Type of dependency will be automatically recognized and proper function or object mock will be automatically generated on the fly (during the build process). There are 3 different types:
- object that implements methods
- function
- node

In case that auto-generated mock doesn't suit our needs, manual mock may be created. It has to be created under `_mocks` directory located next to the mocked file. Manual mock file has to be named after the mocked element with `.mock.brs` postfix e.g. `GlobalNode.mock.brs` for the `GlobalNode.brs` element.

It's also possible to create a common config for the mock. To do so, a file named after the mocked element with `.config.brs` postfix has to be added in the `_mocks` directory. Such config will be automatically imported when a dependency is mocked by the `@mock` annotation.

Example `ExampleService.brs`:
```brightscript
function ExampleService(dependency as Object) as Object
  prototype = {}

  prototype.getData = function (arg as String) as Object
    return { someKey: "someValue" }
  end function

  return prototype
end function
```
`ExampleService.mock.brs`:
```brightscript
function ExampleService(dependency as Object) as Object
  return Mock({
    testComponent: m,
    name: "ExampleService",
    methods: {
      getData: function (arg as Object) as Object
        return m.getDataMock("getData", { arg: arg })
      end function,
    },
  })
end function
```

In the unit tests the special field `__mocks` will be created and configuration can be added:
```brightscript
m.__mocks.exampleService = {
  getData: {
    returnValue: 1,
  },
}
```
The service can be used like a regular object:
```brightscript
 service = ExampleService(dependency)
 data = service.getData("/test")
```

When dependency is mocked (`@mock`).
You can use our `mockFunction` to set returned value of the mocked function. For example.

```brs
it("should return mocked function value", function (_ts as Object) as String
  ' Given
  expected = 123
  mockFunction("functionName").returnedValue(expected)

  ' When
  result = functionReturningFunctionNameResult()

  'Then
  return expect(result).toEqual(expected)
end function)
```

Or you can check if mocked function was called properly

```brs
it("should call functionName once with argument a = 1", function (_ts as Object) as String
  ' When
  result = functionReturningFunctionNameResult()

  'Then
  return [
    expect("functionName").toHaveBeenCalledTimes(1),
    expect("functionName").toHaveBeenCalledWith({ a: 1 }),
  ]
end function)
```

[Here](docs/api/KopytkoMockFunction.md) are listed all `mockFunction` methods.

There are also plenty of examples [here](/example/app/components/_tests/mockExamples.test.brs).

Calls to the methods or constructor can be inspected:
```brightscript
? mockFunction("ExampleService.getData").getCalls()[0].params.arg
? mockFunction("ExampleService").getConstructorCalls()[0].params.dependency
```

## Setup and Teardown

Roku Unit Testing Framework provides the way to execute your custom code before/after every test suite.
However, to give more flexibility, Kopytko Unit Testing Framework overwrites `setUp` and `tearDown` properties of a test suite, so you shouldn't use them. Instead, add your function via `beforeAll` or `afterAll` methods of `KopytkoTestSuite`.
`KopytkoFrameworkTestSuite` already contains some additional code to prepare and clean a test suite from Kopytko ecosystem related stuff.
Notice that if you have test cases of a unit split into few files, every file creates a separate test suite, therefore all `beforeAll` and `afterAll` callbacks will be executed once per a file.

`KopytkoTestSuite` provides additional possibility to run custom code before/after every test suite via `setBeforeEach` and `setAfterEach`
methods.

Functions passed into all these methods and arrays should have just one `ts` argument which is a test suite.

## Limitations
 - The Framework was not tested with the annotations

## API

- [KopytkoTestSuite](docs/api/KopytkoTestSuite.md)
- [KopytkoFrameworkTestSuite](docs/api/KopytkoFrameworkTestSuite.md)
- [KopytkoTestFunctions](docs/api/KopytkoTestFunctions.md)
- [KopytkoExpect](docs/api/KopytkoExpect.md)
- [KopytkoMockFunction](docs/api/KopytkoMockFunction.md)

## Example test app config and unit tests

Go to [/example](example) directory

## Migration from v1 to v2

Version 2 introduces new shorthand functions and because of that, we were able to remove the test suite object argument from the test case function.

Now if you want to get the `ts` (test suite) object, you can get it by calling the `ts()` function in a test case.

In order to not make trouble for projects that already use v1, we introduced a **bs_const** flag [**insertKopytkoUnitTestSuiteArgument**](/example/manifest.js). So if you **don't want to change the current test cases implementation** add it to your manifest with the value **set to true**.

When you want to use our new shorthand methods and you **don't need a test suite object argument**, as you don't use it, **set this flag to false**.

**IMPORTANT: This flag is only temporary and will be removed in the future.
The desired solution is to not use the test suite argument.**
