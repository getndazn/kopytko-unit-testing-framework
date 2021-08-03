# Kopytko Unit Testing Framework
The unit testing framework works on top of the [Roku Unit Testing framework](https://github.com/rokudev/unit-testing-framework). There are some differences between Kopytko and Roku unit testing framework. The main difference is placement of the tests. We believe tests should be close to the tested objects.

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

## Unit Test philosophy
The unit tests can be splitted into multiple files and imported by the packager automatically. Let's consider the following example:
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
function MyServiceTestSuite() as Object
  ts = BaseTestSuite()
  ts.setUp = function ()
    ' do something
  end function

  return ts
end function
```
`MyService_Main.test.brs`
```brightscript
function TestSuite__MyService_Main() as Object
  ts = MyServiceTestSuite()
  ts.name = "MyService - Main"

  ts.addTest("it should create new instance of the service", function () as String
    return ts.assertNotInvalid(MyService())
  end function)

  return ts
end function
```
`MyService_getData.test.brs`
```brightscript
function TestSuite__MyService_getData() as Object
  ts = MyServiceTestSuite()
  ts.name = "MyService - getData"

  ts.addTest("it should return some data", function () as String
   ' Given
    service = MyService()
    expected = { arg: "abc" }

    ' When
    result = service.getData("abc")

    'Then
    return ts.assertEqual(result, expected)
  end function)

  return ts
end function
```
Such structure is understood and imported automatically by the packager.
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

Calls to the methods or constructor can be inspected:
```brightscript
?m.__mocks.exampleService.getData.calls[0].params.arg
?m.__mocks.exampleService.constructorCalls[0].params.dependency
```

## Setup and Teardown
Roku Unit Testing Framework provides the way to execute your custom code before/after every test suite.
However, to give more flexibility, Kopytko Unit Testing Framework overwrites `setUp` and `tearDown` properties of a test suite,
so you shouldn't use them. Instead, add your function into `beforeAll` and `afterAll` array properties of `KopytkoTestSuite`.
`KopytkoFrameworkTestSuite` already contains some additional code to prepare and clean a test suite from Kopytko ecosystem
related stuff.
Notice that if you have test cases of a unit split into few files, every file creates a separate test suite, therefore
`beforeAll` and `afterAll` will be executed once per file.

`KopytkoTestSuite` provides additional possibility to run custom code before/after every test suite via `setBeforeEach` and `setAfterEach`
methods.

Functions passed into all these methods and arrays should have just one `ts` argument which is a test suite.
