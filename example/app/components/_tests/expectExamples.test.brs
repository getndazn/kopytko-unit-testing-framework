' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @mock /components/sum.brs

function TestSuite__expectExamples() as Object
    ts = KopytkoTestSuite()

    ts.setBeforeEach(sub (ts as Object)
      m.__mocks = {}
      m.__mocks.sum = {}
    end sub)
  
    ' ---------------------------------------------------------
    ' toBeInvalid()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toBeInvalid()", function (ts as Object) as String
      ' Given
      value = Invalid
  
      ' Then
      return expect(value).toBeInvalid()
    end function)
  
    ts.addParameterizedTests([
      { value: 4 },
      { value: true },
      { value: "Test Value" },
      { value: { key: "value" } },
      { value: [1, 2, 3] },
      { value: CreateObject("roSGNode", "rectangle") },
    ], "expect(received).not.toBeInvalid()", function (ts as Object, params as Object) as String
  
      ' Then
      return expect(params.value).not.toBeInvalid()
    end function)
  
    ' ---------------------------------------------------------
    ' toBeValid()
    ' ---------------------------------------------------------
    ts.addParameterizedTests([
      { value: 4 },
      { value: true },
      { value: "Test Value" },
      { value: { key: "value" } },
      { value: [1, 2, 3] },
      { value: CreateObject("roSGNode", "rectangle") },
    ], "expect(received).toBeValid()", function (ts as Object, params as Object) as String
  
      ' Then
      return expect(params.value).toBeValid()
    end function)
  
    ts.addTest("expect(received).not.toBeValid()", function (ts as Object) as String
      ' Given
      value = Invalid
  
      ' Then
      return expect(value).not.toBeValid()
    end function)
  
    ' ---------------------------------------------------------
    ' toBeTrue()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toBeTrue()", function (ts as Object) as String
      ' Given
      value = true
  
      ' Then
      return expect(value).toBeTrue()
    end function)
  
    ts.addTest("expect(received).not.toBeTrue()", function (ts as Object) as String
      ' Given
      value = false
  
      ' Then
      return expect(value).not.toBeTrue()
    end function)
  
    ' ---------------------------------------------------------
    ' toBeFalse()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toBeFalse()", function (ts as Object) as String
      ' Given
      value = false
  
      ' Then
      return expect(value).toBeFalse()
    end function)
  
    ts.addTest("expect(received).not.toBeFalse()", function (ts as Object) as String
      ' Given
      value = true
  
      ' Then
      return expect(value).not.toBeFalse()
    end function)
  
    ' ---------------------------------------------------------
    ' toBe()
    ' ---------------------------------------------------------
    ts.addParameterizedTests([
      { value: 4, expectedValue: 4 },
      { value: true, expectedValue: true },
      { value: "Test Value", expectedValue: "Test Value" },
    ], "expect(received).toBe(expected)", function (ts as Object, params as Object) as String
  
      ' Then
      return expect(params.value).toBe(params.expectedValue)
    end function)

    ts.addTest("expect(received).toBe(expected) for scenegraph node", function (ts as Object) as String
      ' Given
      value = CreateObject("roSGNode", "rectangle")
      expectedValue = value
  
      ' Then
      return expect(value).toBe(expectedValue)
    end function)
  
    ts.addParameterizedTests([
      { value: 4, expectedValue: 5 },
      { value: true, expectedValue: false },
      { value: "Test Value", expectedValue: "Another Value" },
      { value: CreateObject("roSGNode", "rectangle"), expectedValue: CreateObject("roSGNode", "rectangle") }
    ], "expect(received).not.toBe(expected)", function (ts as Object, params as Object) as String

      ' Then
      return expect(params.value).not.toBe(params.expectedValue)
    end function)

    ' ---------------------------------------------------------
    ' toEqual()
    ' ---------------------------------------------------------
    ts.addParameterizedTests([
      { value: 4, expectedValue: 4 },
      { value: true, expectedValue: true },
      { value: "Test Value", expectedValue: "Test Value" },
      { value: ["a", "b", "c"], expectedValue: ["a", "b", "c"] }
      { value: { key1: "value1", key2: "value2" }, expectedValue: { key1: "value1", key2: "value2" } }
      { value: CreateObject("roSGNode", "rectangle"), expectedValue: CreateObject("roSGNode", "rectangle") }
    ], "expect(received).toEqual(expected)", function (ts as Object, params as Object) as String
  
      ' Then
      return expect(params.value).toEqual(params.expectedValue)
    end function)

    ts.addTest("expect(received).toEqual(expected) for scenegraph node", function (ts as Object) as String
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
  
    ts.addParameterizedTests([
      { value: 4, expectedValue: 5 },
      { value: true, expectedValue: false },
      { value: "Test Value", expectedValue: "Another Value" },
      { value: ["a", "b", "c"], expectedValue: ["a", "b", "c", "d"] }
      { value: { key1: "value1", key2: "value2" }, expectedValue: { key1: "value1", key3: "value3" } }
    ], "expect(received).not.toEqual(expected)", function (ts as Object, params as Object) as String

      ' Then
      return expect(params.value).not.toEqual(params.expectedValue)
    end function)

    ts.addTest("expect(received).not.toEqual(expected)", function (ts as Object) as String
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
    ts.addParameterizedTests([
      { value: ["a", "b", "c"], expectedValue: "b" },
      { value: ["a", "b", "c", "d"], expectedValue: ["b", "c"] },
      { value: { key1: "value1", key2: "value2" }, expectedValue: {key2: "value2"} },
    ], "expect(received).toContain(expected)", function (ts as Object, params as Object) as String
  
      ' Then
      return expect(params.value).toContain(params.expectedValue)
    end function)

    ts.addTest("expect(received).toContain(expected) to assert fields of scenegraph node", function (ts as Object) as String
      ' Given
      node = CreateObject("roSGNode", "rectangle")
      node.width = 100.0
      node.height = 50.0
  
      ' Then
      return expect(node).toContain({ width: 100.0, height: 50.0 })
    end function)

    ts.addTest("expect(received).toContain(expected) to assert child nodes of scenegraph node", function (ts as Object) as String
      ' Given
      parentNode = CreateObject("roSGNode", "rectangle")
      childNode = CreateObject("roSGNode", "rectangle")
      parentNode.appendChild(childNode)

      ' Then
      return expect(parentNode).toContain(childNode)
    end function)
  
    ts.addParameterizedTests([
      { value: ["a", "b", "c"], expectedValue: "d" },
      { value: ["a", "b", "c", "d"], expectedValue: ["b", "e"] },
      { value: { key1: "value1", key2: "value2" }, expectedValue: {key3: "value3"} },
      { value: CreateObject("roSGNode", "rectangle"), expectedValue: { someKey: "someValue" } }
    ], "expect(received).not.toContain(expected)", function (ts as Object, params as Object) as String
  
      ' Then
      return expect(params.value).not.toContain(params.expectedValue)
    end function)

    ts.addTest("expect(received).not.toContain(expected) to assert child nodes of scenegraph node", function (ts as Object) as String
      ' Given
      parentNode = CreateObject("roSGNode", "rectangle")
      childNode = CreateObject("roSGNode", "rectangle")

      ' Then
      return expect(parentNode).not.toContain(childNode)
    end function)

    ' ---------------------------------------------------------
    ' toHasKey()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toHasKey(expected)", function (ts as Object) as String
      ' Given
      assArray = { key1: "value1", key2: "value2", key3: "value3" }
  
      ' Then
      return expect(assArray).toHasKey("key2")
    end function)
  
    ts.addTest("expect(received).not.toHasKey(expected)", function (ts as Object) as String
      ' Given
      assArray = { key1: "value1", key2: "value2", key3: "value3" }
  
      ' Then
      return expect(assArray).not.toHasKey("key4")
    end function)

    ' ---------------------------------------------------------
    ' toHasKeys()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toHasKeys(expected)", function (ts as Object) as String
      ' Given
      assArray = { key1: "value1", key2: "value2", key3: "value3" }
  
      ' Then
      return expect(assArray).toHasKeys(["key1", "key2"])
    end function)
  
    ts.addTest("expect(received).not.toHasKeys(expected)", function (ts as Object) as String
      ' Given
      assArray = { key1: "value1", key2: "value2", key3: "value3" }
  
      ' Then
      return expect(assArray).not.toHasKeys(["key1", "key4"])
    end function)

    ' ---------------------------------------------------------
    ' toHaveLength()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toHaveLength(expected)", function (ts as Object) as String
      ' Given
      arr = ["value1", "value2", "value3"]
  
      ' Then
      return expect(arr).toHaveLength(3)
    end function)
  
    ts.addTest("expect(received).not.toHaveLength(expected)", function (ts as Object) as String
      ' Given
      arr = ["value1", "value2", "value3"]
  
      ' Then
      return expect(arr).not.toHaveLength(6)
    end function)

    ' ---------------------------------------------------------
    ' toHaveBeenCalled()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toHaveBeenCalled()", function (ts as Object) as String
      ' When
      funcCallingSum()
  
      ' Then
      return expect("sum").toHaveBeenCalled()
    end function)

    ts.addTest("expect(received).not.toHaveBeenCalled()", function (ts as Object) as String
      ' When
      funcNotCallingSum()
  
      ' Then
      return expect("sum").not.toHaveBeenCalled()
    end function)

    ' ---------------------------------------------------------
    ' toHaveBeenCalledTimes()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toHaveBeenCalledTimes(expected)", function (ts as Object) as String
      ' When
      funcCallingSum()
      funcCallingSum()
  
      ' Then
      return expect("sum").toHaveBeenCalledTimes(2)
    end function)

    ts.addTest("expect(received).not.toHaveBeenCalledTimes(expected)", function (ts as Object) as String
      ' When
      funcCallingSum()
      funcCallingSum()
  
      ' Then
      return expect("sum").not.toHaveBeenCalledTimes(1)
    end function)

    ' ---------------------------------------------------------
    ' toHaveBeenCalledWith()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toHaveBeenCalledWith(expected)", function (ts as Object) as String
      ' When
      funcCallingSum(1, 2)
  
      ' Then
      return expect("sum").toHaveBeenCalledWith({ a: 1, b: 2})
    end function)

    ts.addTest("expect(received).not.toHaveBeenCalledWith(expected)", function (ts as Object) as String
      ' When
      funcCallingSum(2, 3)
  
      ' Then
      return expect("sum").not.toHaveBeenCalledWith({ a: 3, b: 2})
    end function)

    ' ---------------------------------------------------------
    ' toHaveBeenLastCalledWith()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toHaveBeenLastCalledWith(expected)", function (ts as Object) as String
      ' When
      funcCallingSum(1, 2)
      funcCallingSum(3, 4)
      funcCallingSum(5, 6)
  
      ' Then
      return expect("sum").toHaveBeenLastCalledWith({ a: 5, b: 6})
    end function)

    ts.addTest("expect(received).not.toHaveBeenLastCalledWith(expected)", function (ts as Object) as String
      ' When
      funcCallingSum(1, 2)
      funcCallingSum(3, 4)
      funcCallingSum(5, 6)
  
      ' Then
      return expect("sum").not.toHaveBeenLastCalledWith({ a: 3, b: 4})
    end function)

    ' ---------------------------------------------------------
    ' toHaveBeenNthCalledWith()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toHaveBeenNthCalledWith(expected)", function (ts as Object) as String
      ' When
      funcCallingSum(1, 2)
      funcCallingSum(3, 4)
      funcCallingSum(5, 6)
  
      ' Then
      return expect("sum").toHaveBeenNthCalledWith(2, { a: 3, b: 4})
    end function)

    ts.addTest("expect(received).not.toHaveBeenNthCalledWith(expected)", function (ts as Object) as String
      ' When
      funcCallingSum(1, 2)
      funcCallingSum(3, 4)
      funcCallingSum(5, 6)
  
      ' Then
      return expect("sum").not.toHaveBeenNthCalledWith(2, { a: 1, b: 2})
    end function)

    ' ---------------------------------------------------------
    ' toThrow()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toThrow()", function (ts as Object) as String

      return expect(function()
        funcWithException()
      end function).toThrow()
    end function)
  
    ts.addTest("expect(received).not.toThrow()", function (ts as Object) as String
  
      return expect(function()
        funcWithNoException()
      end function).not.toThrow()
    end function)
  
    return ts
  end function
  