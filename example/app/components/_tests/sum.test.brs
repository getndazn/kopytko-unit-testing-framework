' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
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

  ts.addParameterizedTests([
    { a: 2, b: 4, expectedSum: 6 },
    { a: 5, b: 10, expectedSum: 15 },
  ], "it should return ${expectedSum} when sum ${a} and ${b}", function (ts as Object, params as Object) as String
    ' When
    result = sum(params.a, params.b)

    ' Then
    return ts.assertEqual(result, params.expectedSum)
  end function)

  return ts
end function
