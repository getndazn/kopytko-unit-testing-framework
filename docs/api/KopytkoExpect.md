# KopytkoExpect API

Implementation of the `expect` function is a bit similar to the jestjs.io one.

It can take any value, or mocked function name as an argument and you can call on it an assert function.

- [Methods](#methods)
  - [`toBe`](#tobe)
  - [`toBeInvalid`](#tobeinvalid)
  - [`toBeValid`](#tobevalid)
  - [`toBeTrue`](#tobetrue)
  - [`toBeFalse`](#tobefalse)
  - [`toEqual`](#toequal)
  - [`toContain`](#tocontain)
  - [`toHaveKey`](#tohavekey)
  - [`toHaveKeys`](#tohavekeys)
  - [`toHaveLength`](#tohavelength)
  - [`toHaveBeenCalled`](#tohavebeencalled)
  - [`toHaveBeenCalledTimes`](#tohavebeencalledtimes)
  - [`toHaveBeenCalledWith`](#tohavebeencalledwith)
  - [`toHaveBeenLastCalledWith`](#tohavebeenlastcalledwith)
  - [`toHaveBeenNthCalledWith`](#tohavebeennthcalledwith)
  - [`toThrow`](#tothrow)
  - [`not`](#not)

## Methods

### `toBe`

Checks equality of two values, or Node reference.

This does not work for object references (only Node).

```brs
it("should pass", function () as String
  return expect(2).toBe(2)
end function)
```

### `toBeInvalid`

Checks if value is invalid.

```brs
it("should pass", function () as String
  return expect(Invalid).toBeInvalid()
end function)
```

### `toBeValid`

Checks if value is valid.

```brs
it("should pass", function () as String
  return expect(1).toBeValid()
end function)
```

### `toBeTrue`

Checks if value is true.

```brs
it("should pass", function () as String
  return expect(true).toBeTrue()
end function)
```

### `toBeFalse`

Checks if value is false.

```brs
it("should pass", function () as String
  return expect(false).toBeFalse()
end function)
```

### `toEqual`

Checks values equality. For primitive values works the same as toBe.

Examples:

For AssociativeArray

```brs
it("should pass", function () as String
  return expect({ a: 2 }).toEqual({ a: 2 })
end function)
```

For Nodes

```brs
it("should pass", function () as String
  nodeA = CreateNode("roSGNode", "Rectangle")
  nodeA.id = "asd"
  nodeB = CreateNode("roSGNode", "Rectangle")
  nodeB.id = "asd"

  return expect(nodeA).toEqual(nodeB)
end function)
```

### `toContain`

Checks if Array/AssociativeArray/Node contains the expected value/subset/node

Examples:

For Array entries

```brs
it("should pass", function () as String
  return expect(["a", "b"]).toContain("a")
end function)
```

For AssociativeArray subset

```brs
it("should pass", function () as String
  return expect({ a: 2, b: 5 }).toContain({ a: 2 })
end function)
```

For Nodes fields

```brs
it("should pass", function () as String
  node = CreateNode("roSGNode", "Rectangle")
  node.id = "asd"

  return expect(node).toContain({ id: "asd" })
end function)
```

For Nodes children

```brs
it("should pass", function () as String
  parent = CreateNode("roSGNode", "Rectangle")
  child = CreateNode("roSGNode", "Rectangle")
  parent.appendChild(child)

  return expect(parent).toContain(child)
end function)
```

### `toHaveKey`

Checks if AssociativeArray contains given key.

```brs
it("should pass", function () as String
  return expect({ a: 2 }).toHaveKey("a")
end function)
```

### `toHaveKeys`

Checks if AssociativeArray contains given keys.

```brs
it("should pass", function () as String
  return expect({ a: 2, b: "asd" }).toHaveKeys(["a", "b"])
end function)
```

### `toHaveLength`

Checks if Array or AssociativeArray has given lenght/count.

```brs
it("should pass", function () as String
  return expect({ a: 2, b: "asd" }).toHaveLength(2)
end function)
```

### `toHaveBeenCalled`

Checks if mocked function was called at least once.

```brs
' @mock /path/to/functionName


it("should pass", function () as String
  return expect("functionName").toHaveBeenCalled()
end function)
```

### `toHaveBeenCalledTimes`

Checks if mocked function was called given times.

```brs
' @mock /path/to/functionName


it("should pass", function () as String
  return expect("functionName").toHaveBeenCalledTimes(1)
end function)
```

### `toHaveBeenCalledWith`

Checks if mocked function was called with given arguments.

Checks if mocked function was called given times.

```brs
' @mock /path/to/functionName


it("should pass", function () as String
  return expect("functionName").toHaveBeenCalledWith({ a: 2 })
end function)
```

#### Strict mode

By default, this function is not in strict mode.
So it will validate only against given arguments.
With strict mode, it checks if all arguments are identical
So this will throw an error.

```brs
' @mock /path/to/functionWithThreeArguments


it("should pass", function () as String
  return expect("functionWithThreeArguments").toHaveBeenCalledWith({ a: 2, b: 3 }, { strict: true })
end function)
```

### `toHaveBeenLastCalledWith`

Checks if mocked function last call was with given arguments.

```brs
' @mock /path/to/functionName


it("should pass", function () as String
  return expect("functionName").toHaveBeenLastCalledWith({ a: 2 })
end function)
```

#### Strict mode

By default, this function is not in strict mode.
So it will validate only against given arguments.
With strict mode, it checks if all arguments are identical
So this will throw an error.

```brs
' @mock /path/to/functionWithThreeArguments


it("should pass", function () as String
  return expect("functionWithThreeArguments").toHaveBeenLastCalledWith({ a: 2, b: 3 }, { strict: true })
end function)
```

### `toHaveBeenNthCalledWith`

Checks if mocked function nth, given, call was executed with given arguments.

```brs
' @mock /path/to/functionName


it("should pass", function () as String
  return expect("functionName").toHaveBeenNthCalledWith(1, { a: 2 })
end function)
```

#### Strict mode

By default, this function is not in strict mode.
So it will validate only against given arguments.
With strict mode, it checks if all arguments are identical
So this will throw an error.

```brs
' @mock /path/to/functionWithThreeArguments


it("should pass", function () as String
  return expect("functionWithThreeArguments").toHaveBeenNthCalledWith(1, { a: 2, b: 3 }, { strict: true })
end function)
```

### `toThrow`

Checks if the function throws an exception.

```brs
it("should pass", function () as String
  return expect(functionThatThrow).toThrow("Error message")
end function)
```

### `not`

Check the opposite of the assert function.

```brs
it("should pass", function () as String
  return expect(1)not.toBe(4)
end function)
```
