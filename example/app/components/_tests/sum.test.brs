' @import /components/KopytkoTestSuite.brs from @kopytko/unit-testing-framework
function TestSuite__sum() as Object
  ts = KopytkoTestSuite()

  ts.addTest("it should return a sum of two numbers", function (ts as Object) as String
    ' Given
    a = 1
    b = 1

    ' When
    result = sum(a, b)

    ' Then
    return ts.assertEqual(result, 2)
  end function)

  return ts
end function
