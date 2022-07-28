' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework

function TestSuite__sum() as Object
  ts = KopytkoTestSuite()
  ts.name = "Example - function"

  it("should return a sum of two numbers", function () as String
    ' Given
    a = 1
    b = 1

    ' When
    result = sum(a, b)

    ' Then
    return expect(result).toBe(2)
  end function)

  itEach([
    { a: 2, b: 4, expectedSum: 6 },
    { a: 5, b: 10, expectedSum: 15 },
  ], "should return ${expectedSum} when sum ${a} and ${b}", function (params as Object) as String
    ' When
    result = sum(params.a, params.b)

    ' Then
    return expect(result).toBe(params.expectedSum)
  end function)

  return ts
end function
