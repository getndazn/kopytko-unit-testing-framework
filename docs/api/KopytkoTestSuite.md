# KopytkoTestSuite API

## Methods
- [`setAfterAll(callback)`](#setafterallcallback)
- [`setAfterEach(callback)`](#setaftereachcallback)
- [`setBeforeAll(callback)`](#setbeforeallcallback)
- [`setBeforeEach(callback)`](#setbeforeeachcallback)

## Callbacks
- [`setupOrTeardownCallback`](#setuporteardowncallback)

---

## Reference

### `setAfterAll(callback)`
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

### `setAfterEach(callback)`
Runs a function after each one of the tests in the file completes.

Params:
- `callback`: [`setupOrTeardownCallback`](#setuporteardowncallback)

### `setBeforeAll(callback)`
Runs a function before all the tests in the file run.

Params:
- `callback`: [`setupOrTeardownCallback`](#setuporteardowncallback)

### `setBeforeEach(callback)`
Runs a function before each one of the tests in the file runs.

Params:
- `callback`: [`setupOrTeardownCallback`](#setuporteardowncallback)

### `setupOrTeardownCallback`
Params:
- `ts`: `Object` the TestSuite object
