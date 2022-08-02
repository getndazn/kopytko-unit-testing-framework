# KopytkoMockFunction API

The implementation of the `mockFunction` is a bit similar to the jestjs.io one.

It takes mocked function name as an argument and you can call on it mock functions.

The function name should be a string, if the function returns an object and you want to mock its methods you can use ".".

```brs
mockFunction("functionName")
mockFunction("Service.serviceMethod")
```

- [Methods](#methods)
  - [`clear`](#clear)
  - [`getCalls`](#getcalls)
  - [`getContructorCalls`](#getcontructorcalls)
  - [`implementation`](#implementation)
  - [`returnValue`](#returnvalue)
  - [`resolvedValue`](#resolvedvalue)
  - [`rejectedValue`](#rejectedvalue)
  - [`throw`](#throw)

## Methods

### `clear`

Clears all mock data set for this test case

```brs
mockFunction("functionName").clear()
```

### `getCalls`

Returns an array with all function mock calls,

remember that all calls are cleared before each test case execution.

```brs
calls = mockFunction("functionName").getCalls()
```

### `getContructorCalls`

Returns an array with all function mock constructor calls,

remember that all calls are cleared before each test case execution.

```brs
contructorCalls = mockFunction("functionName").getContructorCalls()
```

### `implementation`

It mocks function implementation

Implementation function takes 2 arguments:
- params - object, where keys are names of the original implementation arguments, and values are arguments value
- context - the test suite context

```brs
m.__expectedValue = 10

mockFunction("functionName").implementation(function (_params as Object, context as Object) as FunctionReturnType
  return context.__expectedValue
end function)
```

### `returnValue`

It mocks function return value

```brs
calls = mockFunction("functionName").returnValue("no this will be returned by this funciton")
```

### `resolvedValue`

For the convenience you can mock promise resolve value,
but for this, you need to import PromiseResolve from the kopytko-utils package.

It mocks function promise resolved value

```brs
mockFunction("functionName").resolvedValue(12)
```

### `rejectedValue`

For the convenience you can mock promise reject value,
but for this, you need to import PromiseReject from the kopytko-utils package.

It mocks function promise rejected value

```brs
mockFunction("functionName").rejectedValue("error message")
```

### `throw`

It mocks function exception.

It can take a string or an error object. Exactly the same values you can pass to the throw statement.

```brs
mockFunction("functionName").throw("Mocked error message")
```
