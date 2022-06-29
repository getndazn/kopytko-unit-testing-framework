' Assert functions in this file:
'
'     kptk_toBeInvalid
'     kptk_toBeValid
'     kptk_toBeTruthy
'     kptk_toBeFalsy
'     kptk_toBe
'     kptk_toContain
'     kptk_toHaveLength
'     kptk_toHaveBeenCalled
'     kptk_toHaveBeenCalledTimes
'     kptk_toHaveBeenCalledWith
'     kptk_toHaveBeenLastCalledWith
'     kptk_toHaveBeenNthCalledWith
'     kptk_toThrow
'     kptk_not

' ----------------------------------------------------------------
' To ensure if value is Invalid
'
' @return Empty string (if invalid) OR an error message
' ----------------------------------------------------------------
function kptk_toBeInvalid() as String
  MATCHER_NAME = "toBeInvalid()"
  errorMsg = matcherErrorMessage(MATCHER_NAME, Invalid, m._received, { isNot : m._isNot })

  assertMsg = m._ts.assertInvalid(m._received, errorMsg)

  ' if matcher has been called with expect.not
  if (m._isNot) then return kptk_utils_ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg)

  return assertMsg
end function

' ----------------------------------------------------------------
' To ensure if value is valid
'
' @return Empty string (if valid) OR an error message
' ----------------------------------------------------------------
function kptk_toBeValid() as String
  MATCHER_NAME = "toBeValid()"
  errorMsg = matcherErrorMessage(MATCHER_NAME, "Value to be valid", m._received, { isNot : m._isNot })

  assertMsg = m._ts.assertNotInvalid(m._received, errorMsg)

  ' if matcher has been called with expect.not
  if (m._isNot) then return kptk_utils_ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg)

  return assertMsg
end function

' ----------------------------------------------------------------
' To ensure if value is true
'
' @return Empty string (if true) OR an error message
' ----------------------------------------------------------------
function kptk_toBeTruthy() as String
  MATCHER_NAME = "toBeTruthy()"
  errorMsg = matcherErrorMessage(MATCHER_NAME, true, m._received, { isNot : m._isNot })

  assertMsg = m._ts.assertTrue(m._received, errorMsg)

  ' if matcher has been called with expect.not
  if (m._isNot) then return kptk_utils_ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg)

  return assertMsg
end function

' ----------------------------------------------------------------
' To ensure if value is false
'
' @return Empty string (if false) OR an error message
' ----------------------------------------------------------------
function kptk_toBeFalsy() as String
  MATCHER_NAME = "toBeFalsy()"
  errorMsg = matcherErrorMessage(MATCHER_NAME, false, m._received, { isNot : m._isNot })

  assertMsg = m._ts.assertFalse(m._received, errorMsg)

  ' if matcher has been called with expect.not
  if (m._isNot) then return kptk_utils_ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg)

  return assertMsg
end function

' ----------------------------------------------------------------
' To ensure if value is eqaul to the expected value
'
' @param value (dynamic) - Expected value 
'
' @return Empty string (if equal) OR an error message
' ----------------------------------------------------------------
function kptk_toBe(value as Dynamic) as String
  MATCHER_NAME = "toBe(expected)"
  errorMsg = matcherErrorMessage(MATCHER_NAME, value, m._received, { isNot : m._isNot })

  assertMsg = m._ts.assertEqual(value, m._received)

  ' if matcher has been called with expect.not
  if (m._isNot) then return kptk_utils_ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg)

  return kptk_utils_ternary(assertMsg = "", "", errorMsg)
end function

' ----------------------------------------------------------------
' To ensure if Array or AssociativeArray contains the expected value
'
' @param value (dynamic) - Expected value 
' @param key (dynamic) - A key name for associative array.
'
' @return Empty string (if contains) OR an error message
' ----------------------------------------------------------------
function kptk_toContain(value as Dynamic, key = Invalid as Dynamic) as String
  MATCHER_NAME = "toContain(expected)"
  errorMsg = matcherErrorMessage(MATCHER_NAME, value, m._received, { isNot : m._isNot })

  assertMsg = m._ts.assertArrayContains(m._received, value, key)

  ' if matcher has been called with expect.not
  if (m._isNot) then return kptk_utils_ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg + assertMsg)

  return kptk_utils_ternary(assertMsg = "", "", errorMsg + assertMsg)
end function

' ----------------------------------------------------------------
' To ensure if Array or AssociativeArray has expected length
'
' @param number (dynamic) - Expected length 
'
' @return Empty string (if expected length) OR an error message
' ----------------------------------------------------------------
function kptk_toHaveLength(number as Dynamic) as String
  MATCHER_NAME = "toHaveLength(expected)"
  errorMsg = matcherErrorMessage(MATCHER_NAME, number, m._received, { isNot : m._isNot })

  assertMsg = m._ts.assertArrayCount(m._received, number)

  ' if matcher has been called with expect.not
  if (m._isNot) then return kptk_utils_ternary(TF_Utils__IsNotEmptyString(assertMsg), "", errorMsg + assertMsg)

  return kptk_utils_ternary(assertMsg = "", "", errorMsg + assertMsg)
end function

' ----------------------------------------------------------------
' To ensure if a mock function was called at least once
'
' @return Empty string (if called) OR an error message
' ----------------------------------------------------------------
function kptk_toHaveBeenCalled() as String
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
  passed = kptk_utils_ternary(m._isNot, NOT passed, passed)

  return kptk_utils_ternary(passed, "", matcherErrorMessage(MATCHER_NAME, ">=1", numberOfCalls, { isNot : m._isNot }, EXPECTED_STR, RECEIVED_STR))
end function

' ----------------------------------------------------------------
' To ensure if a mock function was called exact number of times
'
' @param number (integer) - Expected number of mock function calls
'
' @return empty string (if called) OR an error message
' ----------------------------------------------------------------
function kptk_toHaveBeenCalledTimes(number as Integer) as String
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
  passed = kptk_utils_ternary(m._isNot, NOT passed, passed)

  return kptk_utils_ternary(passed, "", matcherErrorMessage(MATCHER_NAME, number, numberOfCalls, { isNot : m._isNot }, EXPECTED_STR, RECEIVED_STR))
end function

' ----------------------------------------------------------------
' To ensure if a mock function was called with specific arguments
'
' @param params (object) - Expected arguments
'
' @return empty string (if called) OR an error message
' ----------------------------------------------------------------
function kptk_toHaveBeenCalledWith(params as Object) as String
  MATCHER_NAME = "toHaveBeenCalledWith(expected)"

  methodMock = m._ts.getProperty(GetGlobalAA().__mocks, m._received, { calls: [] })
  methodMockCalls = []
  callsParams = []
  
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
  passed = kptk_utils_ternary(m._isNot, NOT passed, passed)

  return kptk_utils_ternary(passed, "", matcherErrorMessage(MATCHER_NAME, params, callsParams, { isNot : m._isNot }) + Substitute("Number of calls: {0}", kptk_utils_asString(numberOfCalls)))
end function


' ----------------------------------------------------------------
' To ensure if a mock function was last called with specific arguments
'
' @param params (object) - Expected arguments
'
' @return empty string (if called) OR an error message
' ----------------------------------------------------------------
function kptk_toHaveBeenLastCalledWith(params as Object) as String
  MATCHER_NAME = "toHaveBeenLastCalledWith(expected)"

  methodMock = m._ts.getProperty(GetGlobalAA().__mocks, m._received, { calls: [] })
  numberOfCalls = methodMock.calls.count()
  actualParams = Invalid
  passed = false

  if (numberOfCalls > 0)
    ' check if last call of the function made with expected params
    lastCall = methodMock.calls[numberOfCalls - 1]
    actualParams = lastCall.params
    passed = m._ts.eqValues(actualParams, params)
  end if

  ' if matcher has been called with expect.not
  passed = kptk_utils_ternary(m._isNot, NOT passed, passed)

  return kptk_utils_ternary(passed, "", matcherErrorMessage(MATCHER_NAME, params, actualParams, { isNot : m._isNot }) + Substitute("Number of calls: {0}", kptk_utils_asString(numberOfCalls)))
end function

' ----------------------------------------------------------------
' To ensure if a mock function was last called with specific arguments
'
' @param nthCall (Integer) - Call index which needs to be checked
' @param params (object) - Expected arguments
'
' @return empty string (if called) OR an error message
' ----------------------------------------------------------------
function kptk_toHaveBeenNthCalledWith(nthCall as Integer, params as Object) as String
  MATCHER_NAME = "toHaveBeenNthCalledWith(expected)"

  methodMock = m._ts.getProperty(GetGlobalAA().__mocks, m._received, { calls: [] })
  numberOfCalls = methodMock.calls.count()
  actualParams = Invalid
  passed = false

  if (numberOfCalls > 0)
    ' check if nth call of the function made with expected params
    methodNthCall = methodMock.calls[nthCall - 1]
    actualParams = methodNthCall.params
    passed = m._ts.eqValues(actualParams, params)
  end if

  ' if matcher has been called with expect.not
  passed = kptk_utils_ternary(m._isNot, NOT passed, passed)

  return kptk_utils_ternary(passed, "", matcherErrorMessage(MATCHER_NAME, params, actualParams, { isNot : m._isNot }) + Substitute("Number of calls: {0}", kptk_utils_asString(numberOfCalls)))
end function

' ----------------------------------------------------------------
' To ensure if a function throws an exception
' Must wrap the code which needs to be asserted in a function, otherwise the error will not be caught and the assertion will fail.
'
' @return empty string (if throws) OR an error message
' ----------------------------------------------------------------
function kptk_toThrow()
  ' return error if received value is not a function
  if (NOT TF_Utils__IsFunction(m._received)) then return "Received value must be a function"

  MATCHER_NAME = "toThrow()"
  passed = false

  try
    m._received()
  catch e
    passed = true
  end try

  ' if matcher has been called with expect.not
  passed = kptk_utils_ternary(m._isNot, NOT passed, passed)

  return kptk_utils_ternary(passed, "", matcherErrorMessage(MATCHER_NAME, "throws", e, { isNot : m._isNot }))
end function

' ----------------------------------------------------------------
' If you know how to test something, .not lets you test its opposite
'
' @param this (object) - An expect object in which reference it should be called
'
' @return Expect object with '_isNot' value as 'true'
' ----------------------------------------------------------------
function kptk_not(this as Object) as Object
  notExpect = {}
  notExpect.append(this)
  notExpect.addReplace("_isNot", true)
  return notExpect
end function

' ----------------------------------------------------------------
' Utils
' ----------------------------------------------------------------

function matcherErrorMessage(matcherName as String, expected = Invalid as Dynamic, actual = Invalid as Dynamic, options = {} as Object, expectedString = "Expected" as String, receivedString = "Received" as String) as String
  TRAILING_STR = " ; "
  isNot = (options.isNot <> Invalid AND options.isNot)
  ' format matcher name
  matcherString = "expect(received)" + kptk_utils_ternary(isNot, ".not", "") + "." + matcherName + " - "

  if (TF_Utils__IsNotEmptyString(expectedString))
    ' format expected string
    matcherString += Substitute("{0}: {1} {2}", expectedString, kptk_utils_ternary(isNot, "[not]", ""), kptk_utils_asString(expected)) + TRAILING_STR
  end if

  if (TF_Utils__IsNotEmptyString(receivedString))
    ' format received string
    matcherString += Substitute("{0}: {1}", receivedString, kptk_utils_asString(actual)) + TRAILING_STR
  end if

  return matcherString
end function

function kptk_utils_asString(value as Dynamic) as String
  if (not TF_Utils__IsValid(value))
    return "Invalid"
  else if (TF_Utils__IsValid(GetInterface(value, "ifToStr")))
    return value.toStr()
  else if (TF_Utils__IsValid(GetInterface(value, "ifAssociativeArray")) OR TF_Utils__IsValid(GetInterface(value, "ifArray")))
    return FormatJson(value)
  else
    return ""
  end if
end function

function kptk_utils_ternary(conditionResult as Boolean, trueReturnValue as Dynamic, falseReturnValue as Dynamic) as Dynamic
  if (conditionResult)
    return trueReturnValue
  end if

  return falseReturnValue
end function
