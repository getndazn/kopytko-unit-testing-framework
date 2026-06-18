' ----------------------------------------------------------------
' Calls ts.addTest with the same arguments
' ----------------------------------------------------------------
sub test(testName as String, func as Function)
  getTestSuite().addTest(testName, func)
end sub

' ----------------------------------------------------------------
' Calls ts.addParameterizedTests with the same arguments
' ----------------------------------------------------------------
sub testEach(paramsList as Object, testName as String, func as Function)
  getTestSuite().addParameterizedTests(paramsList, testName, func)
end sub

' ----------------------------------------------------------------
' Calls ts.addTest with the same arguments,
' adds "it " to the beginning of the test name
' ----------------------------------------------------------------
sub it(testName as String, func as Function)
  getTestSuite().addTest("it " + testName, func)
end sub

' ----------------------------------------------------------------
' Calls ts.addParameterizedTests with the same arguments,
' adds "it " to the beginning of the test name
' ----------------------------------------------------------------
sub itEach(paramsList as Object, testName as String, func as Function)
  getTestSuite().addParameterizedTests(paramsList, "it " + testName, func)
end sub

' ----------------------------------------------------------------
' Calls ts.setBeforeAll with the same arguments
' ----------------------------------------------------------------
sub beforeAll(callback as Function)
  getTestSuite().setBeforeAll(callback)
end sub

' ----------------------------------------------------------------
' Calls ts.setBeforeEach with the same arguments
' ----------------------------------------------------------------
sub beforeEach(callback as Function)
  getTestSuite().setBeforeEach(callback)
end sub

' ----------------------------------------------------------------
' Calls ts.setAfterEach with the same arguments
' ----------------------------------------------------------------
sub afterEach(callback as Function)
  getTestSuite().setAfterEach(callback)
end sub

' ----------------------------------------------------------------
' Calls ts.setAfterAll with the same arguments
' ----------------------------------------------------------------
sub afterAll(callback as Function)
  getTestSuite().setAfterAll(callback)
end sub

' ----------------------------------------------------------------
' Returns test suite object
' ----------------------------------------------------------------
function getTestSuite() as Object
  return m["$$testSuite"]
end function
