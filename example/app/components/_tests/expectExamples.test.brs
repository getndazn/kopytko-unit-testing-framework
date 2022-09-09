' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @mock /components/sum.brs

function TestSuite__expectExamples() as Object
    ts = KopytkoTestSuite()
    ts.name = "Expect Examples"
  
    ' ---------------------------------------------------------
    ' toBeInvalid()
    ' ---------------------------------------------------------
    it("expect(Invalid).toBeInvalid()", function () as String
      ' Given
      value = Invalid
  
      ' Then
      return expect(value).toBeInvalid()
    end function)
  
    itEach([
      4,
      true,
      "Test Value",
      { key: "value" },
      [1, 2, 3],
      CreateObject("roSGNode", "rectangle"),
    ], "expect(nonInvalidValue).not.toBeInvalid()", function (value as Object) as String
  
      ' Then
      return expect(value).not.toBeInvalid()
    end function)
  
    ' ---------------------------------------------------------
    ' toBeValid()
    ' ---------------------------------------------------------
    itEach([
      4,
      true,
      "Test Value",
      { key: "value" },
      [1, 2, 3],
      CreateObject("roSGNode", "rectangle"),
    ], "expect(nonInvalidValue).toBeValid()", function (value as Object) as String
  
      ' Then
      return expect(value).toBeValid()
    end function)
  
    it("expect(Invalid).not.toBeValid()", function () as String
      ' Given
      value = Invalid
  
      ' Then
      return expect(value).not.toBeValid()
    end function)
  
    ' ---------------------------------------------------------
    ' toBeTrue()
    ' ---------------------------------------------------------
    it("expect(true).toBeTrue()", function () as String
      ' Given
      value = true
  
      ' Then
      return expect(value).toBeTrue()
    end function)
  
    it("expect(false).not.toBeTrue()", function () as String
      ' Given
      value = false
  
      ' Then
      return expect(value).not.toBeTrue()
    end function)
  
    ' ---------------------------------------------------------
    ' toBeFalse()
    ' ---------------------------------------------------------
    it("expect(false).toBeFalse()", function () as String
      ' Given
      value = false
  
      ' Then
      return expect(value).toBeFalse()
    end function)
  
    it("expect(true).not.toBeFalse()", function () as String
      ' Given
      value = true
  
      ' Then
      return expect(value).not.toBeFalse()
    end function)
  
    ' ---------------------------------------------------------
    ' toBe()
    ' ---------------------------------------------------------
    itEach([
      { value: 4, expectedValue: 4 },
      { value: true, expectedValue: true },
      { value: "Test Value", expectedValue: "Test Value" },
    ], "expect(${value}).toBe(${expectedValue})", function (params as Object) as String
  
      ' Then
      return expect(params.value).toBe(params.expectedValue)
    end function)

    it("expect(nodeObjectReference).toBe(theSameNodeObjectReference) for scenegraph node", function () as String
      ' Given
      value = CreateObject("roSGNode", "rectangle")
      expectedValue = value
  
      ' Then
      return expect(value).toBe(expectedValue)
    end function)
  
    itEach([
      { value: 4, expectedValue: 5 },
      { value: true, expectedValue: false },
      { value: "Test Value", expectedValue: "Another Value" },
      { value: CreateObject("roSGNode", "rectangle"), expectedValue: CreateObject("roSGNode", "rectangle") }
    ], "expect(${value}).not.toBe(${expectedValue})", function (params as Object) as String

      ' Then
      return expect(params.value).not.toBe(params.expectedValue)
    end function)

    ' ---------------------------------------------------------
    ' toEqual()
    ' ---------------------------------------------------------
    itEach([
      { value: 4, expectedValue: 4 },
      { value: true, expectedValue: true },
      { value: "Test Value", expectedValue: "Test Value" },
      { value: ["a", "b", "c"], expectedValue: ["a", "b", "c"] }
      { value: { key1: "value1", key2: "value2" }, expectedValue: { key1: "value1", key2: "value2" } }
      { value: CreateObject("roSGNode", "rectangle"), expectedValue: CreateObject("roSGNode", "rectangle") }
    ], "expect(value).toEqual(theSameValue)", function (params as Object) as String
  
      ' Then
      return expect(params.value).toEqual(params.expectedValue)
    end function)

    it("expect(node).toEqual(anotherNodeWithSameFieldsAndChildren) for scenegraph node", function () as String
      ' When
      value = CreateObject("roSGNode", "rectangle")
      value.id = "TestID"
      value.createChild("rectangle")

      expectedValue = CreateObject("roSGNode", "rectangle")
      expectedValue.id = "TestID"
      expectedValue.createChild("rectangle")
      ' Then
      return expect(value).toEqual(expectedValue)
    end function)
  
    itEach([
      { value: 4, expectedValue: 5 },
      { value: true, expectedValue: false },
      { value: "Test Value", expectedValue: "Another Value" },
      { value: ["a", "b", "c"], expectedValue: ["a", "b", "c", "d"] }
      { value: { key1: "value1", key2: "value2" }, expectedValue: { key1: "value1", key3: "value3" } }
    ], "expect(value).not.toEqual(notTheSameValue)", function (params as Object) as String

      ' Then
      return expect(params.value).not.toEqual(params.expectedValue)
    end function)

    it("expect(node).not.toEqual(nodeWithDifferentFields)", function () as String
      ' Given
      value = CreateObject("roSGNode", "rectangle")
      value.id = "id_1"
      expectedValue = CreateObject("roSGNode", "rectangle")
      expectedValue.id = "id_2"

      ' Then
      return expect(value).not.toEqual(expectedValue)
    end function)

    ' ---------------------------------------------------------
    ' toContain()
    ' ---------------------------------------------------------
    itEach([
      { value: ["a", "b", "c"], expectedValue: "b" },
      { value: ["a", "b", "c", "d"], expectedValue: ["b", "c"] },
      { value: { key1: "value1", key2: "value2" }, expectedValue: {key2: "value2"} },
    ], "expect(object).toContain(valueOrFields)", function (params as Object) as String
  
      ' Then
      return expect(params.value).toContain(params.expectedValue)
    end function)

    it("expect(node).toContain(fields)", function () as String
      ' Given
      node = CreateObject("roSGNode", "rectangle")
      node.width = 100.0
      node.height = 50.0
  
      ' Then
      return expect(node).toContain({ width: 100.0, height: 50.0 })
    end function)

    it("expect(node).toContain(child)", function () as String
      ' Given
      parentNode = CreateObject("roSGNode", "rectangle")
      childNode = CreateObject("roSGNode", "rectangle")
      parentNode.appendChild(childNode)

      ' Then
      return expect(parentNode).toContain(childNode)
    end function)
  
    itEach([
      { value: ["a", "b", "c"], expectedValue: "d" },
      { value: ["a", "b", "c", "d"], expectedValue: ["b", "e"] },
      { value: { key1: "value1", key2: "value2" }, expectedValue: { key3: "value3" } },
      { value: CreateObject("roSGNode", "rectangle"), expectedValue: { someKey: "someValue" } }
    ], "expect(object).not.toContain(valueOrFields)", function (params as Object) as String
  
      ' Then
      return expect(params.value).not.toContain(params.expectedValue)
    end function)

    it("expect(parentSGNode).not.toContain(childSGNode)", function () as String
      ' Given
      parentNode = CreateObject("roSGNode", "rectangle")
      childNode = CreateObject("roSGNode", "rectangle")

      ' Then
      return expect(parentNode).not.toContain(childNode)
    end function)

    ' ---------------------------------------------------------
    ' toHaveKey()
    ' ---------------------------------------------------------
    it("expect({ key1: value1, key2: value2, key3: value3 }).toHaveKey(key2)", function () as String
      ' Given
      assArray = { key1: "value1", key2: "value2", key3: "value3" }
  
      ' Then
      return expect(assArray).toHaveKey("key2")
    end function)
  
    it("expect({ key1: value1, key2: value2, key3: value3 }).not.toHaveKey(key4)", function () as String
      ' Given
      assArray = { key1: "value1", key2: "value2", key3: "value3" }
  
      ' Then
      return expect(assArray).not.toHaveKey("key4")
    end function)

    ' ---------------------------------------------------------
    ' toHaveKeys()
    ' ---------------------------------------------------------
    it("expect({ key1: value1, key2: value2, key3: value3 }).toHaveKeys([key1, key2])", function () as String
      ' Given
      assArray = { key1: "value1", key2: "value2", key3: "value3" }
  
      ' Then
      return expect(assArray).toHaveKeys(["key1", "key2"])
    end function)
  
    it("expect({ key1: value1, key2: value2, key3: value3 }).not.toHaveKeys([key1, key4])", function () as String
      ' Given
      assArray = { key1: "value1", key2: "value2", key3: "value3" }
  
      ' Then
      return expect(assArray).not.toHaveKeys(["key1", "key4"])
    end function)

    ' ---------------------------------------------------------
    ' toHaveLength()
    ' ---------------------------------------------------------
    it("expect([value1, value2, value3]).toHaveLength(3)", function () as String
      ' Given
      arr = ["value1", "value2", "value3"]
  
      ' Then
      return expect(arr).toHaveLength(3)
    end function)
  
    it("expect([value1, value2, value3]).not.toHaveLength(6)", function () as String
      ' Given
      arr = ["value1", "value2", "value3"]
  
      ' Then
      return expect(arr).not.toHaveLength(6)
    end function)

    ' ---------------------------------------------------------
    ' toHaveBeenCalled()
    ' ---------------------------------------------------------
    it("expect(funcCallingSum).toHaveBeenCalled()", function () as String
      ' When
      funcCallingSum()
  
      ' Then
      return expect("sum").toHaveBeenCalled()
    end function)

    it("expect(funcNotCallingSum).not.toHaveBeenCalled()", function () as String
      ' When
      funcNotCallingSum()
  
      ' Then
      return expect("sum").not.toHaveBeenCalled()
    end function)

    ' ---------------------------------------------------------
    ' toHaveBeenCalledTimes()
    ' ---------------------------------------------------------
    it("expect(funcCallingSum).toHaveBeenCalledTimes(2)", function () as String
      ' When
      funcCallingSum()
      funcCallingSum()
  
      ' Then
      return expect("sum").toHaveBeenCalledTimes(2)
    end function)

    it("expect(funcCallingSum).not.toHaveBeenCalledTimes(1)", function () as String
      ' When
      funcCallingSum()
      funcCallingSum()
  
      ' Then
      return expect("sum").not.toHaveBeenCalledTimes(1)
    end function)

    ' ---------------------------------------------------------
    ' toHaveBeenCalledWith()
    ' ---------------------------------------------------------
    it("expect(funcCallingSum).toHaveBeenCalledWith({ a: 1 })", function () as String
      ' When
      funcCallingSum(1, 2)
  
      ' Then
      return expect("sum").toHaveBeenCalledWith({ a: 1 })
    end function)

    it("expect(funcCallingSum).toHaveBeenCalledWith({ a: 1, b: 2 }) with strict mode", function () as String
      ' When
      funcCallingSum(1, 2)
  
      ' Then
      return expect("sum").toHaveBeenCalledWith({ a: 1, b: 2 }, { strict: true })
    end function)

    it("expect(funcCallingSum).not.toHaveBeenCalledWith({ a: 3, b: 2 })", function () as String
      ' When
      funcCallingSum(2, 3)
  
      ' Then
      return expect("sum").not.toHaveBeenCalledWith({ a: 3, b: 2 })
    end function)

    ' ---------------------------------------------------------
    ' toHaveBeenLastCalledWith()
    ' ---------------------------------------------------------
    it("expect(funcCallingSum).toHaveBeenLastCalledWith({ a: 5 })", function () as String
      ' When
      funcCallingSum(1, 2)
      funcCallingSum(3, 4)
      funcCallingSum(5, 6)
  
      ' Then
      return expect("sum").toHaveBeenLastCalledWith({ a: 5 })
    end function)

    it("expect(funcCallingSum).toHaveBeenLastCalledWith({ a: 5, b: 6 }) with strict mode", function () as String
      ' When
      funcCallingSum(1, 2)
      funcCallingSum(3, 4)
      funcCallingSum(5, 6)
  
      ' Then
      return expect("sum").toHaveBeenLastCalledWith({ a: 5, b: 6 }, { strict: true })
    end function)

    it("expect(funcCallingSum).not.toHaveBeenLastCalledWith({ a: 3, b: 4 })", function () as String
      ' When
      funcCallingSum(1, 2)
      funcCallingSum(3, 4)
      funcCallingSum(5, 6)
  
      ' Then
      return expect("sum").not.toHaveBeenLastCalledWith({ a: 3, b: 4 })
    end function)

    ' ---------------------------------------------------------
    ' toHaveBeenNthCalledWith()
    ' ---------------------------------------------------------
    it("expect(funcCallingSum).toHaveBeenNthCalledWith(2, { a: 3 })", function () as String
      ' When
      funcCallingSum(1, 2)
      funcCallingSum(3, 4)
      funcCallingSum(5, 6)
  
      ' Then
      return expect("sum").toHaveBeenNthCalledWith(2, { a: 3 })
    end function)

    it("expect(funcCallingSum).toHaveBeenNthCalledWith(2, { a: 3, b: 4 }) with strict mode", function () as String
      ' When
      funcCallingSum(1, 2)
      funcCallingSum(3, 4)
      funcCallingSum(5, 6)
  
      ' Then
      return expect("sum").toHaveBeenNthCalledWith(2, { a: 3, b: 4 }, { strict: true })
    end function)

    it("expect(funcCallingSum).not.toHaveBeenNthCalledWith(2, { a: 1, b: 2 })", function () as String
      ' When
      funcCallingSum(1, 2)
      funcCallingSum(3, 4)
      funcCallingSum(5, 6)
  
      ' Then
      return expect("sum").not.toHaveBeenNthCalledWith(2, { a: 1, b: 2 })
    end function)

    ' ---------------------------------------------------------
    ' toThrow()
    ' ---------------------------------------------------------
    it("expect(funcWithException).toThrow()", function () as String
      return expect(funcWithException).toThrow()
    end function)
  
    it("expect(funcWithNoException).not.toThrow()", function () as String
      return expect(funcWithNoException).not.toThrow()
    end function)
  
    return ts
  end function
  