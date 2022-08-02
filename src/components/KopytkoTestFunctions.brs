' ----------------------------------------------------------------
' Calls ts.addTest with the same arguments,
' adds "it " to the beginning of the test name
' ----------------------------------------------------------------
sub it(testName as String, func as Function)
  ts().addTest("it " + testName, func)
end sub

' ----------------------------------------------------------------
' Calls ts.addParameterizedTests with the same arguments,
' adds "it " to the beginning of the test name
' ----------------------------------------------------------------
sub itEach(paramsList as Object, testName as String, func as Function)
  ts().addParameterizedTests(paramsList, "it " + testName, func)
end sub

' ----------------------------------------------------------------
' Calls ts.setBeforeAll with the same arguments
' ----------------------------------------------------------------
sub beforeAll(callback as Function)
  ts().setBeforeAll(callback)
end sub

' ----------------------------------------------------------------
' Calls ts.setBeforeEach with the same arguments
' ----------------------------------------------------------------
sub beforeEach(callback as Function)
  ts().setBeforeEach(callback)
end sub

' ----------------------------------------------------------------
' Calls ts.setAfterEach with the same arguments
' ----------------------------------------------------------------
sub afterEach(callback as Function)
  ts().setAfterEach(callback)
end sub

' ----------------------------------------------------------------
' Calls ts.setAfterAll with the same arguments
' ----------------------------------------------------------------
sub afterAll(callback as Function)
  ts().setAfterAll(callback)
end sub

' ----------------------------------------------------------------
' Returns test suite object
' ----------------------------------------------------------------
function ts() as Object
  return m["$$ts"]
end function
