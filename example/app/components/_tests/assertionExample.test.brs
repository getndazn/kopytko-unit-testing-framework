' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @mock /components/sum.brs

function TestSuite__assertionExample() as Object
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
      return ts.expect(value).toBeInvalid()
    end function)
  
    ts.addTest("expect(received).not.toBeInvalid()", function (ts as Object) as String
      ' Given
      value = "Test Value"
  
      ' Then
      return ts.expect(value).not.toBeInvalid()
    end function)
  
    ' ---------------------------------------------------------
    ' toBeValid()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toBeValid()", function (ts as Object) as String
      ' Given
      value = 2
  
      ' Then
      return ts.expect(value).toBeValid()
    end function)
  
    ts.addTest("expect(received).not.toBeValid()", function (ts as Object) as String
      ' Given
      value = Invalid
  
      ' Then
      return ts.expect(value).not.toBeValid()
    end function)
  
    ' ---------------------------------------------------------
    ' toBeTruthy()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toBeTruthy()", function (ts as Object) as String
      ' Given
      value = true
  
      ' Then
      return ts.expect(value).toBeTruthy()
    end function)
  
    ts.addTest("expect(received).not.toBeTruthy()", function (ts as Object) as String
      ' Given
      value = false
  
      ' Then
      return ts.expect(value).not.toBeTruthy()
    end function)
  
    ' ---------------------------------------------------------
    ' toBeFalsy()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toBeFalsy()", function (ts as Object) as String
      ' Given
      value = false
  
      ' Then
      return ts.expect(value).toBeFalsy()
    end function)
  
    ts.addTest("expect(received).not.toBeFalsy()", function (ts as Object) as String
      ' Given
      value = true
  
      ' Then
      return ts.expect(value).not.toBeFalsy()
    end function)
  
    ' ---------------------------------------------------------
    ' toBe()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toBe(expected)", function (ts as Object) as String
      ' Given
      value = {key: "value"}
  
      ' Then
      return ts.expect(value).toBe({key: "value"})
    end function)
  
    ts.addTest("expect(received).not.toBe(expected)", function (ts as Object) as String
      ' Given
      value = 5
  
      ' Then
      return ts.expect(value).not.toBe(4)
    end function)

    ' ---------------------------------------------------------
    ' toContain()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toContain(expected)", function (ts as Object) as String
      ' Given
      arr = ["value1", "value2", "value3"]
  
      ' Then
      return ts.expect(arr).toContain("value2")
    end function)
  
    ts.addTest("expect(received).not.toContain(expected)", function (ts as Object) as String
      ' Given
      arr = ["value1", "value2", "value3"]
  
      ' Then
      return ts.expect(arr).not.toContain("value4")
    end function)

    ' ---------------------------------------------------------
    ' toContainsSubset()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toContainsSubset(expected)", function (ts as Object) as String
      ' Given
      arr = ["value1", "value2", "value3"]
  
      ' Then
      return ts.expect(arr).toContainsSubset(["value2", "value3"])
    end function)
  
    ts.addTest("expect(received).not.toContainsSubset(expected)", function (ts as Object) as String
      ' Given
      arr = ["value1", "value2", "value3"]
  
      ' Then
      return ts.expect(arr).not.toContainsSubset(["value3", "value4"])
    end function)

    ' ---------------------------------------------------------
    ' toHasKey()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toHasKey(expected)", function (ts as Object) as String
      ' Given
      assArray = { key1: "value1", key2: "value2", key3: "value3" }
  
      ' Then
      return ts.expect(assArray).toHasKey("key2")
    end function)
  
    ts.addTest("expect(received).not.toHasKey(expected)", function (ts as Object) as String
      ' Given
      assArray = { key1: "value1", key2: "value2", key3: "value3" }
  
      ' Then
      return ts.expect(assArray).not.toHasKey("key4")
    end function)

    ' ---------------------------------------------------------
    ' toHasKeys()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toHasKeys(expected)", function (ts as Object) as String
      ' Given
      assArray = { key1: "value1", key2: "value2", key3: "value3" }
  
      ' Then
      return ts.expect(assArray).toHasKeys(["key1", "key2"])
    end function)
  
    ts.addTest("expect(received).not.toHasKeys(expected)", function (ts as Object) as String
      ' Given
      assArray = { key1: "value1", key2: "value2", key3: "value3" }
  
      ' Then
      return ts.expect(assArray).not.toHasKeys(["key1", "key4"])
    end function)

    ' ---------------------------------------------------------
    ' toHaveLength()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toHaveLength(expected)", function (ts as Object) as String
      ' Given
      arr = ["value1", "value2", "value3"]
  
      ' Then
      return ts.expect(arr).toHaveLength(3)
    end function)
  
    ts.addTest("expect(received).not.toHaveLength(expected)", function (ts as Object) as String
      ' Given
      arr = ["value1", "value2", "value3"]
  
      ' Then
      return ts.expect(arr).not.toHaveLength(6)
    end function)

    ' ---------------------------------------------------------
    ' toHaveBeenCalled()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toHaveBeenCalled()", function (ts as Object) as String
      ' When
      funcCallingSum()
  
      ' Then
      return ts.expect("sum").toHaveBeenCalled()
    end function)

    ts.addTest("expect(received).not.toHaveBeenCalled()", function (ts as Object) as String
      ' When
      funcNotCallingSum()
  
      ' Then
      return ts.expect("sum").not.toHaveBeenCalled()
    end function)

    ' ---------------------------------------------------------
    ' toHaveBeenCalledTimes()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toHaveBeenCalledTimes(expected)", function (ts as Object) as String
      ' When
      funcCallingSum()
      funcCallingSum()
  
      ' Then
      return ts.expect("sum").toHaveBeenCalledTimes(2)
    end function)

    ts.addTest("expect(received).not.toHaveBeenCalledTimes(expected)", function (ts as Object) as String
      ' When
      funcCallingSum()
      funcCallingSum()
  
      ' Then
      return ts.expect("sum").not.toHaveBeenCalledTimes(1)
    end function)

    ' ---------------------------------------------------------
    ' toHaveBeenCalledWith()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toHaveBeenCalledWith(expected)", function (ts as Object) as String
      ' When
      funcCallingSum(1, 2)
  
      ' Then
      return ts.expect("sum").toHaveBeenCalledWith({ a: 1, b: 2})
    end function)

    ts.addTest("expect(received).not.toHaveBeenCalledWith(expected)", function (ts as Object) as String
      ' When
      funcCallingSum(2, 3)
  
      ' Then
      return ts.expect("sum").not.toHaveBeenCalledWith({ a: 3, b: 2})
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
      return ts.expect("sum").toHaveBeenLastCalledWith({ a: 5, b: 6})
    end function)

    ts.addTest("expect(received).not.toHaveBeenLastCalledWith(expected)", function (ts as Object) as String
      ' When
      funcCallingSum(1, 2)
      funcCallingSum(3, 4)
      funcCallingSum(5, 6)
  
      ' Then
      return ts.expect("sum").not.toHaveBeenLastCalledWith({ a: 3, b: 4})
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
      return ts.expect("sum").toHaveBeenNthCalledWith(2, { a: 3, b: 4})
    end function)

    ts.addTest("expect(received).not.toHaveBeenNthCalledWith(expected)", function (ts as Object) as String
      ' When
      funcCallingSum(1, 2)
      funcCallingSum(3, 4)
      funcCallingSum(5, 6)
  
      ' Then
      return ts.expect("sum").not.toHaveBeenNthCalledWith(2, { a: 1, b: 2})
    end function)

    ' ---------------------------------------------------------
    ' toThrow()
    ' ---------------------------------------------------------
    ts.addTest("expect(received).toThrow()", function (ts as Object) as String

      return ts.expect(function()
        funcWithException()
      end function).toThrow()
    end function)
  
    ts.addTest("expect(received).not.toThrow()", function (ts as Object) as String
  
      return ts.expect(function()
        funcWithNoException()
      end function).not.toThrow()
    end function)
  
    return ts
  end function
  