# KopytkoTestFunctions API

- [Functions](#functions)
  - [`test`](#test)
  - [`testEach`](#testeach)
  - [`it`](#it)
  - [`itEach`](#iteach)
  - [`beforeAll`](#beforeall)
  - [`beforeEach`](#beforeeach)
  - [`afterEach`](#aftereach)
  - [`afterAll`](#afterall)
  - [`ts`](#ts)

In order to make developer live easier there are shorhands for all test function

There is bs_const variable - **insertKopytkoUnitTestSuiteArgument**

- when **true** all test case functions and hooks need ts (TestSuite) argument

```brs
it("should check if true is true", function (_ts as Object) as String
  return expect(true).toBeTrue()
end function)
```

- when **false** all test case functions and hooks do not need ts (TestSuite) argument

```brs
it("should check if true is true", function () as String
  return expect(true).toBeTrue()
end function)
```

## Functions

### `test`

This is a shorthand for the `ts.addTest`.

```brs
test("it should check if true is true", function (_ts as Object) as String
  return expect(true).toBeTrue()
end function)
```

### `testEach`

This is a shorthand for the `ts.addParameterizedTests`.

```brs
testEach([
  { value: 2, expectedValue: 2 },
  { value: "asd", expectedValue: "asd" },
], "it should check if ${value} is ${expectedValue}", function (_ts as Object, params as Object) as String
  return expect(params.value).toBe(params.expectedValue)
end function)
```

### `it`

This is a shorthand for the `ts.addTest`.

It adds "it " to the beggining of the test name.

```brs
it("should check if true is true", function (_ts as Object) as String
  return expect(true).toBeTrue()
end function)
```

### `itEach`

This is a shorthand for the `ts.addParameterizedTests`.

It adds "it " to the beggining of the test name.

```brs
itEach([
  { value: 2, expectedValue: 2 },
  { value: "asd", expectedValue: "asd" },
], "should check if ${value} is ${expectedValue}", function (_ts as Object, params as Object) as String
  return expect(params.value).toBe(params.expectedValue)
end function)
```

### `beforeAll`

This is a shorthand for the `ts.setBeforeAll`.

```brs
beforeAll(sub (_ts as Object)
  ? "This will be printed before first test case execution"
end sub)
```

### `beforeEach`

This is a shorthand for the `ts.setBeforeEach`.

```brs
beforeEach(sub (_ts as Object)
  ? "This will be printed before every test case execution"
end sub)
```

### `afterEach`

This is a shorthand for the `ts.setAfterEach`.

```brs
afterEach(sub (_ts as Object)
  ? "This will be printed after every test case execution"
end sub)
```

### `afterAll`

This is a shorthand for the `ts.setAfterAll`.

```brs
afterAll(sub (_ts as Object)
  ? "This will be printed after last test case execution"
end sub)
```

### `ts`

Returns Test Suite object (ts).

```brs
ts().isMatch({ a: 1 }, { a: 1 })
```
