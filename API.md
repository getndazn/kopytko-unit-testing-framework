# KopytkoTestSuite

## Methods
- [`setAfterAll(callback)`](#setafterallcallback)
- [`setAfterEach(callback)`](#setaftereachcallback)
- [`setBeforeAll(callback)`](#setbeforeallcallback)
- [`setBeforeEach(callback)`](#setbeforeeachcallback)

## Interfaces
- [`setupOrTeardownCallback`](#setuporteardowncallback)

---

## Reference

### `setAfterAll(callback)`
Runs a function after all the tests in the file have completed.

Params:
- `callback`: `setupOrTeardownCallback`

Example:
```brightscript
ts = KopytkoTestSuite()
ts.setAfterAll(sub (ts as Object)
  ?"TestSuite finished: ";ts.name
end sub)
```

### `setAfterEach(callback)`
Runs a function after each one of the tests in the file completes.

Params:
- `callback`: `setupOrTeardownCallback`

### `setBeforeAll(callback)`
Runs a function before all the tests in the file run.

Params:
- `callback`: `setupOrTeardownCallback`

### `setBeforeEach(callback)`
Runs a function before each one of the tests in the file runs.

Params:
- `callback`: `setupOrTeardownCallback`

### `setupOrTeardownCallback`
A function used as a callback in some methods.

Params:
- `ts`: `Object` the TestSuite object
