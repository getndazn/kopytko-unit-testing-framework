' Assert functions in this file:
'
'     toBe
'     toBeFalse
'     toBeInvalid
'     toBeTrue
'     toBeValid
'     toContain
'     toEqual
'     toHaveKey
'     toHaveKeys
'     toHaveLength
'     toHaveBeenCalled
'     toHaveBeenCalledTimes
'     toHaveBeenCalledWith
'     toHaveBeenLastCalledWith
'     toHaveBeenNthCalledWith
'     toThrow
'     not


' ----------------------------------------------------------------
' The expect function is used every time you want to test a value. 
' You will rarely call expect by itself. 
' Instead, you will use expect along with a "matcher" function to assert something about a value

' @param value (dynamic) - Value which needs to be asserted

' @return An object having all the assertion/ matcher methods
' ----------------------------------------------------------------
function expect(value as Dynamic) as Object
  context = {}
  context._ts = GetGlobalAA()["$$ts"]
  context._received = Invalid
  context._isNot = false

  ' assign received value if received value is initialized and valid
  if (TF_Utils__IsValid(value)) then context._received = value

  ' Matcher functions

  ' ----------------------------------------------------------------
  ' To compare primitive values or to check referential identity of node instances
  ' It fails for object types as object referencee check is not supported in BrightScript
  '
  ' @param value (dynamic) - Expected value 
  '
  ' @return Empty string (if equal) OR an error message
  ' ----------------------------------------------------------------
  context.toBe = function (value as Dynamic) as String
    MATCHER_NAME = "toBe(expected)"
    errorMsg = m._matcherErrorMessage(MATCHER_NAME, value, m._received, { isNot : m._isNot })

    ' Retrun error if received value is object type as referencee check is not supported in BrightScript
    if (m._isList(m._received) OR m._isArray(m._received) OR m._isAssociativeArray(m._received))
      return errorMsg + "Reference assertion is not allowed for object types. Please use 'toEqual' for value assertion"
    end if

    assertMsg = m._ts.assertEqual(value, m._received)

    ' if matcher has been called with expect.not
    if (m._isNot) then return m._ts.ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg)

    return m._ts.ternary(assertMsg = "", "", errorMsg)
  end function

  ' ----------------------------------------------------------------
  ' To ensure if value is false
  '
  ' @return Empty string (if false) OR an error message
  ' ----------------------------------------------------------------
  context.toBeFalse = function () as String
    MATCHER_NAME = "toBeFalse()"
    errorMsg = m._matcherErrorMessage(MATCHER_NAME, false, m._received, { isNot : m._isNot })

    assertMsg = m._ts.assertFalse(m._received, errorMsg)

    ' if matcher has been called with expect.not
    if (m._isNot) then return m._ts.ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg)

    return assertMsg
  end function

  ' ----------------------------------------------------------------
  ' To ensure if value is Invalid
  '
  ' @return Empty string (if invalid) OR an error message
  ' ----------------------------------------------------------------
  context.toBeInvalid = function () as String
    MATCHER_NAME = "toBeInvalid()"
    errorMsg = m._matcherErrorMessage(MATCHER_NAME, Invalid, m._received, { isNot : m._isNot })

    assertMsg = m._ts.assertInvalid(m._received, errorMsg)

    ' if matcher has been called with expect.not
    if (m._isNot) then return m._ts.ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg)

    return assertMsg
  end function

  ' ----------------------------------------------------------------
  ' To ensure if value is true
  '
  ' @return Empty string (if true) OR an error message
  ' ----------------------------------------------------------------
  context.toBeTrue = function () as String
    MATCHER_NAME = "toBeTrue()"
    errorMsg = m._matcherErrorMessage(MATCHER_NAME, true, m._received, { isNot : m._isNot })

    assertMsg = m._ts.assertTrue(m._received, errorMsg)

    ' if matcher has been called with expect.not
    if (m._isNot) then return m._ts.ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg)

    return assertMsg
  end function

  ' ----------------------------------------------------------------
  ' To ensure if value is valid
  '
  ' @return Empty string (if valid) OR an error message
  ' ----------------------------------------------------------------
  context.toBeValid = function () as String
    MATCHER_NAME = "toBeValid()"
    errorMsg = m._matcherErrorMessage(MATCHER_NAME, "Value to be valid", m._received, { isNot : m._isNot })

    assertMsg = m._ts.assertNotInvalid(m._received, errorMsg)

    ' if matcher has been called with expect.not
    if (m._isNot) then return m._ts.ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg)

    return assertMsg
  end function

  ' ----------------------------------------------------------------
  ' To ensure if Array/AssociativeArray/node contains the expected value/subset/node
  '
  ' @param value (dynamic) - Expected value
  '
  ' @return Empty string (if contains) OR an error message
  ' ----------------------------------------------------------------
  context.toContain = function (value as Dynamic) as String
    MATCHER_NAME = "toContain(expected)"
    errorMsg = m._matcherErrorMessage(MATCHER_NAME, value, m._received, { isNot : m._isNot })

    if (m._isSGNode(m._received))
      assertMsg = m._assertNodeContains(m._received, value)
    else if (m._isAssociativeArray(m._received))
      assertMsg = m._assertAAContains(m._received, value)
    else if (m._isArray(m._received))
      assertMsg = m._assertArrayContains(m._received, value)
    else
      return errorMsg + "Input value should be an Array, Associative Array or SG Node."
    end if

    ' if matcher has been called with expect.not
    if (m._isNot) then return m._ts.ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg + assertMsg)

    return m._ts.ternary(assertMsg = "", "", errorMsg + assertMsg)
  end function

  ' ----------------------------------------------------------------
  ' To ensure if value is eqaul to the expected value
  '
  ' @param value (dynamic) - Expected value 
  '
  ' @return Empty string (if equal) OR an error message
  ' ----------------------------------------------------------------
  context.toEqual = function (value as Dynamic) as String
    MATCHER_NAME = "toEqual(expected)"
    errorMsg = m._matcherErrorMessage(MATCHER_NAME, value, m._received, { isNot : m._isNot })

    if (m._isSGNode(m._received))
      assertMsg = m._ts.assertNodesAreEqual(m._received, value)
    else
      assertMsg = m._ts.assertEqual(value, m._received)
    end if

    ' if matcher has been called with expect.not
    if (m._isNot) then return m._ts.ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg)

    return m._ts.ternary(assertMsg = "", "", errorMsg)
  end function

  ' ----------------------------------------------------------------
  ' To ensure if AssociativeArray has the expected key
  '
  ' @param key (dynamic) - A key name for associative array.
  '
  ' @return Empty string (if contains) OR an error message
  ' ----------------------------------------------------------------
  context.toHaveKey = function (key as Dynamic) as String
    MATCHER_NAME = "toHaveKey(expected)"
    errorMsg = m._matcherErrorMessage(MATCHER_NAME, key, m._received, { isNot : m._isNot })

    assertMsg = m._ts.assertAAHasKey(m._received, key)

    ' if matcher has been called with expect.not
    if (m._isNot) then return m._ts.ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg + assertMsg)

    return m._ts.ternary(assertMsg = "", "", errorMsg + assertMsg)
  end function

  ' ----------------------------------------------------------------
  ' To ensure if AssociativeArray has the expected keys
  '
  ' @param keys (object) - array of expected keys
  '
  ' @return Empty string (if contains) OR an error message
  ' ----------------------------------------------------------------
  context.toHaveKeys = function (keys as Object) as String
    MATCHER_NAME = "toHaveKeys(expected)"
    errorMsg = m._matcherErrorMessage(MATCHER_NAME, keys, m._received, { isNot : m._isNot })

    assertMsg = m._ts.assertAAHasKeys(m._received, keys)

    ' if matcher has been called with expect.not
    if (m._isNot) then return m._ts.ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg + assertMsg)

    return m._ts.ternary(assertMsg = "", "", errorMsg + assertMsg)
  end function

  ' ----------------------------------------------------------------
  ' To ensure if a mock function was called at least once
  '
  ' @return Empty string (if called) OR an error message
  ' ----------------------------------------------------------------
  context.toHaveBeenCalled = function () as String
    MATCHER_NAME = "toHaveBeenCalled()"
    EXPECTED_STR = "Expected number of calls"
    RECEIVED_STR = "Received number of calls"
    
    methodMock = m._ts.getProperty(GetGlobalAA().__mocks, m._received, { calls: [] })
    numberOfCalls = 0
    
    if (TF_Utils__IsValid(methodMock.calls))
      numberOfCalls = methodMock.calls.count()
    end if
  
    passed = (numberOfCalls > 0)
    ' if matcher has been called with expect.not
    passed = m._ts.ternary(m._isNot, NOT passed, passed)

    return m._ts.ternary(passed, "", m._matcherErrorMessage(MATCHER_NAME, ">=1", numberOfCalls, { isNot : m._isNot }, EXPECTED_STR, RECEIVED_STR))
  end function

  ' ----------------------------------------------------------------
  ' To ensure if a mock function was called exact number of times
  '
  ' @param number (integer) - Expected number of mock function calls
  '
  ' @return empty string (if called) OR an error message
  ' ----------------------------------------------------------------
  context.toHaveBeenCalledTimes = function (number as Integer) as String
    MATCHER_NAME = "toHaveBeenCalledTimes(expected)"
    EXPECTED_STR = "Expected number of calls"
    RECEIVED_STR = "Received number of calls"

    methodMock = m._ts.getProperty(GetGlobalAA().__mocks, m._received, { calls: [] })
    numberOfCalls = 0
    
    if (TF_Utils__IsValid(methodMock.calls))
      numberOfCalls = methodMock.calls.count()
    end if

    passed = (numberOfCalls = number)
    ' if matcher has been called with expect.not
    passed = m._ts.ternary(m._isNot, NOT passed, passed)

    return m._ts.ternary(passed, "", m._matcherErrorMessage(MATCHER_NAME, number, numberOfCalls, { isNot : m._isNot }, EXPECTED_STR, RECEIVED_STR))
  end function

  ' ----------------------------------------------------------------
  ' To ensure if a mock function was called with specific arguments
  '
  ' @param params (object) - Expected arguments
  '
  ' @return empty string (if called) OR an error message
  ' ----------------------------------------------------------------
  context.toHaveBeenCalledWith = function (params as Object) as String
    MATCHER_NAME = "toHaveBeenCalledWith(expected)"

    methodMock = m._ts.getProperty(GetGlobalAA().__mocks, m._received, { calls: [] })
    methodMockCalls = []
    callsParams = []
    passed = false
    
    if (TF_Utils__IsValid(methodMock.calls))
      methodMockCalls = methodMock.calls
    end if

    numberOfCalls = methodMockCalls.count()

    for each methodCall in methodMockCalls
      callsParams.push(methodCall.params)
      if (m._ts.eqValues(methodCall.params, params))
        passed = true
        exit for
      else
        passed = false
      end if
    end for

    ' if matcher has been called with expect.not
    passed = m._ts.ternary(m._isNot, NOT passed, passed)

    return m._ts.ternary(passed, "", m._matcherErrorMessage(MATCHER_NAME, params, callsParams, { isNot : m._isNot }) + Substitute("Number of calls: {0}", m._asString(numberOfCalls)))
  end function

  ' ----------------------------------------------------------------
  ' To ensure if a mock function was last called with specific arguments
  '
  ' @param params (object) - Expected arguments
  '
  ' @return empty string (if called) OR an error message
  ' ----------------------------------------------------------------
  context.toHaveBeenLastCalledWith = function (params as Object) as String
    MATCHER_NAME = "toHaveBeenLastCalledWith(expected)"

    methodMock = m._ts.getProperty(GetGlobalAA().__mocks, m._received, { calls: [] })
    numberOfCalls = 0
    actualParams = Invalid
    passed = false

    if (TF_Utils__IsValid(methodMock.calls))
      numberOfCalls = methodMock.calls.count()
    end if

    if (numberOfCalls > 0)
      ' check if last call of the function made with expected params
      lastCall = methodMock.calls[numberOfCalls - 1]
      actualParams = lastCall.params
      passed = m._ts.eqValues(actualParams, params)
    end if

    ' if matcher has been called with expect.not
    passed = m._ts.ternary(m._isNot, NOT passed, passed)

    return m._ts.ternary(passed, "", m._matcherErrorMessage(MATCHER_NAME, params, actualParams, { isNot : m._isNot }) + Substitute("Number of calls: {0}", m._asString(numberOfCalls)))
  end function

  ' ----------------------------------------------------------------
  ' To ensure if a mock function was last called with specific arguments
  '
  ' @param nthCall (Integer) - Call index which needs to be checked
  ' @param params (object) - Expected arguments
  '
  ' @return empty string (if called) OR an error message
  ' ----------------------------------------------------------------
  context.toHaveBeenNthCalledWith = function (nthCall as Integer, params as Object) as String
    MATCHER_NAME = "toHaveBeenNthCalledWith(expected)"

    methodMock = m._ts.getProperty(GetGlobalAA().__mocks, m._received, { calls: [] })
    numberOfCalls = 0
    actualParams = Invalid
    passed = false

    if (TF_Utils__IsValid(methodMock.calls))
      numberOfCalls = methodMock.calls.count()
    end if

    if (numberOfCalls > 0)
      ' check if nth call of the function made with expected params
      methodNthCall = methodMock.calls[nthCall - 1]
      actualParams = methodNthCall.params
      passed = m._ts.eqValues(actualParams, params)
    end if

    ' if matcher has been called with expect.not
    passed = m._ts.ternary(m._isNot, NOT passed, passed)

    return m._ts.ternary(passed, "", m._matcherErrorMessage(MATCHER_NAME, params, actualParams, { isNot : m._isNot }) + Substitute("Number of calls: {0}", m._asString(numberOfCalls)))
  end function

  ' ----------------------------------------------------------------
  ' To ensure if Array or AssociativeArray has expected length
  '
  ' @param number (dynamic) - Expected length 
  '
  ' @return Empty string (if expected length) OR an error message
  ' ----------------------------------------------------------------
  context.toHaveLength = function (number as Dynamic) as String
    MATCHER_NAME = "toHaveLength(expected)"
    errorMsg = m._matcherErrorMessage(MATCHER_NAME, number, m._received, { isNot : m._isNot })

    assertMsg = m._ts.assertArrayCount(m._received, number)

    ' if matcher has been called with expect.not
    if (m._isNot) then return m._ts.ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg + assertMsg)

    return m._ts.ternary(assertMsg = "", "", errorMsg + assertMsg)
  end function

  ' ----------------------------------------------------------------
  ' To ensure if a function throws an exception
  ' Must wrap the code which needs to be asserted in a function, otherwise the error will not be caught and the assertion will fail.
  '
  ' @return empty string (if throws) OR an error message
  ' ----------------------------------------------------------------
  context.toThrow = function (expectedError = Invalid as Dynamic) as String
    ' return error if received value is not a function
    if (NOT TF_Utils__IsFunction(m._received)) then return "Received value must be a function"

    MATCHER_NAME = "toThrow([error])"
    passed = false
    expected = m._ts.ternary(expectedError = Invalid, "throws", expectedError)
    received = Invalid

    try
      m._received()
    catch error
      if (expectedError <> Invalid)
        if (m._ts.getType(expectedError) = "roString")
          passed = (expectedError = error.message)
          received = error.message
        else if (m._ts.getType(expectedError) = "roAssociativeArray")
          passed = m._ts.isMatch(expectedError, error)
          received = error
        else
          return "The received error is not a String nor an AssociativeArray"
        end if
      else
        passed = true
      end if
    end try

    ' if matcher has been called with expect.not
    passed = m._ts.ternary(m._isNot, NOT passed, passed)

    return m._ts.ternary(passed, "", m._matcherErrorMessage(MATCHER_NAME, expected, received, { isNot : m._isNot }))
  end function

  ' ----------------------------------------------------------------
  ' Utils
  ' ----------------------------------------------------------------

  context._matcherErrorMessage = function (matcherName as String, expected = Invalid as Dynamic, actual = Invalid as Dynamic, options = {} as Object, expectedString = "Expected" as String, receivedString = "Received" as String) as String
    TRAILING_STR = " ; "
    isNot = (options.isNot <> Invalid AND options.isNot)
    ' format matcher name
    matcherString = "expect(received)" + m._ts.ternary(isNot, ".not", "") + "." + matcherName + " - "

    if (TF_Utils__IsNotEmptyString(expectedString))
      ' format expected string
      matcherString += Substitute("{0}: {1} {2}", expectedString, m._ts.ternary(isNot, "[not]", ""), m._asString(expected)) + TRAILING_STR
    end if

    if (TF_Utils__IsNotEmptyString(receivedString))
      ' format received string
      matcherString += Substitute("{0}: {1}", receivedString, m._asString(actual)) + TRAILING_STR
    end if

    return matcherString
  end function

  context._asString = function (value as Dynamic) as String
    if (NOT TF_Utils__IsValid(value))
      return "Invalid"
    else if (TF_Utils__IsValid(GetInterface(value, "ifToStr")))
      return value.toStr()
    else if (m._isAssociativeArray(value) OR m._isArray(value))
      return FormatJson(value)
    else if (m._isSGNode(value))
      return FormatJson(value.getFields())
    else
      return ""
    end if
  end function

  context._isArray = function (value as Dynamic) as Boolean
    return TF_Utils__IsValid(value) AND m._ts.getType(value) = "roArray"
  end function

  context._isAssociativeArray = function (value as Dynamic) as Boolean
    return TF_Utils__IsValid(value) AND m._ts.getType(value) = "roAssociativeArray"
  end function

  context._isSGNode = function (value as Dynamic) as Boolean
    return TF_Utils__IsValid(value) AND m._ts.getType(value) = "roSGNode"
  end function

  context._isList = function (value as Dynamic) as Boolean
    return TF_Utils__IsValid(value) AND m._ts.getType(value) = "roList"
  end function
  
  context._assertNodeContains = function (node as Object, subset as Dynamic) as String
    if (m._isAssociativeArray(subset))
      obj = node.getFields()
      for each key in subset.keys()
        if (NOT m._ts.isMatch(subset[key], obj[key]))
          return "Node fields does not contain expected values."
        end if
      end for
    else if (m._isSGNode(subset))
      return m._ts.ternary(m._ts.NodeUtils().findChildById(node, (subset.getFields()).id) <> Invalid, "", "Node does not contain expected child node")
    else
      return "Received value is a Node. Expected value should be an AssociativeArray or Node."
    end if

    return ""
  end function

  context._assertAAContains = function (obj as Object, subObj as Dynamic) as String
    if (NOT m._isAssociativeArray(subObj))
      return "Received value is an AssociativeArray. Expected value should also be an AssociativeArray."
    end if

    for each key in subObj.keys()
      if (NOT m._ts.isMatch(subObj[key], obj[key]))
        return "AssociativeArray does not contain expected value."
      end if
    end for

    return ""
  end function

  context._assertArrayContains = function (array as Dynamic, value as Dynamic) as String
    if (m._isArray(value))
      assertMsg = m._ts.assertArrayContainsSubset(array, value)
    else
      assertMsg = m._ts.assertArrayContains(array, value)
    end if

    return assertMsg
  end function

  ' ----------------------------------------------------------------
  ' If you know how to test something, .not lets you test its opposite
  '
  ' @param this (object) - An expect object in which reference it should be called
  '
  ' @return Expect object with '_isNot' value as 'true'
  ' ----------------------------------------------------------------
  context.not = (function (this as Object) as Object
    notExpect = {}
    notExpect.append(this)
    notExpect.addReplace("_isNot", true)
    return notExpect
  end function)(context)

  return context
end function
