# KopytkoTestSuite API

## Methods
- [`addParameterizedTests`](#addparameterizedtests)
- [`assertNodesAreEqual`](#assertnodesareequal)
- [`assertMethodWasCalled`](#assertmethodwascalled)
- [`assertMethodWasNotCalled`](#assertmethodwasnotcalled)
- [`setAfterAll`](#setafterall)
- [`setAfterEach`](#setafterea)
- [`setBeforeAll`](#setbeforeall)
- [`setBeforeEach`](#setbeforeeach)

## Callbacks
- [`setupOrTeardownCallback`](#setuporteardowncallback)

---

## Reference

### `addParameterizedTests`
Allows to test multiple parameters in a sequence. The `testName` string can be interpolated with values that implement `ifToStr` interface. For instance:
```brightscript
ts.addParameterizedTests([
  1,
  2
], "should check if the {0} value is greater than 0", function (ts as Object, param as Integer) as String
  return ts.assertTrue(param > 0)
end function)
```
or with object:
```brightscript
ts.addParameterizedTests([
  { value: 1, expected: true },
  { value: 2, expected: true },
], "should check if the ${value} value is greater than 0", function (ts as Object, param as Integer) as String
  return ts.assertEqual(param.value > 0, param.expected)
end function)
```

Params:
- `paramsList`: `Object` - array of test values
- `testName`: `String` - test description
- `testFunction`: `Function` - takes the arguments:
  - `ts`: `Object` - the TestSuite object
  - `param`: `Dynamic` - the single value from the array

### `assertNodesAreEqual`
Recursively checks if two given nodes are equal. This is not simple comparision of node references. The method deeply compares node's field values including their children.

Params:
- `expected`: `Object` - node
- `tested`: `Object` - node
- `msg = ""`: `String` - additional message when test fails

### `assertMethodWasCalled`
It checks if the mocked method/function is called. It works with manual and automatic mocks. For example:
```brightscript
' My tested entities
function add(a as Integer, b as Integer) as Integer
  return a + b
end function

function Math() as Object
  prototype = {}

  prototype.add = function (a as Integer, b as Integer) as Integer
    return a + b
  end sub

  return prototype
end function

' My test suite
@mock sum.brs
@mock Math.brs
' ...
ts.addTest("checks if function was called", function (ts as Object) as String
  result = add(1, 2)
  return ts.assertMethodWasCalled("add", { a: 1, b: 2 }, { times: 1, strict: true })
end function)
' ...
ts.addTest("checks if methods was called", function (ts as Object) as String
  result = Math().add(1, 2)
  return ts.assertMethodWasCalled("Math.add", { a: 1, b: 2 }, { times: 1, strict: true })
end function)
```

Params:
- `methodPath`: `String` - function or method name
- `params = {}`: `Object` - function or method arguments
- `options = {}`: `Object`
  - `times`: `Integer` - how many times it should be called
  - `strict`: `Boolean` - affects how the params are compared. When `true` the params object must match the arguments types and values (1 to 1 equality). If `false` the params object can contain some of the passed arguments that are tested
- `msg = ""`: `String` - additional message when test fails


### `assertMethodWasNotCalled`
Opposite to `assertMethodWasCalled`. It checks if function/method was not called with given params or times.

Params:
- `methodPath`: `String` - function or method name
- `params = {}`: `Object` - function or method arguments
- `options = {}`: `Object`
  - `times`: `Integer` - how many times it should be called
  - `strict`: `Boolean` - affects how the params are compared. When `true` the params object must match the arguments types and values (1 to 1 equality). If `false` the params object can contain some of the passed arguments that are tested
- `msg = ""`: `String` - additional message when test fails

### `setAfterAll`
Runs a function after all the tests in the file have completed.

Params:
- `callback`: [`setupOrTeardownCallback`](#setuporteardowncallback)

Example:
```brightscript
ts = KopytkoTestSuite()
ts.setAfterAll(sub (ts as Object)
  ?"TestSuite finished: ";ts.name
end sub)
```

### `setAfterEach`
Runs a function after each one of the tests in the file completes.

Params:
- `callback`: [`setupOrTeardownCallback`](#setuporteardowncallback)

### `setBeforeAll`
Runs a function before all the tests in the file run.

Params:
- `callback`: [`setupOrTeardownCallback`](#setuporteardowncallback)

### `setBeforeEach`
Runs a function before each one of the tests in the file runs.

Params:
- `callback`: [`setupOrTeardownCallback`](#setuporteardowncallback)

### `setupOrTeardownCallback`
Params:
- `ts`: `Object` - the TestSuite object
