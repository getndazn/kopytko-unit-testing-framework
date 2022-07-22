' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @mock /components/divide.brs

function TestSuite__failingTestsExamples() as Object
  ts = KopytkoTestSuite()
  ts.name = "Example - failing tests"

  it("should fail when assert fails", function (_ts as Object) as String
    return expect(1).toBe(3)
  end function)

  it("should fail when one of asserts fails", function (_ts as Object) as Object
    return [
      expect(1).toBe(1),
      expect(2).toBe(3),
      expect(3).toBe(3),
    ]
  end function)

  it("should fail when all of asserts fail", function (_ts as Object) as Object
    return [
      expect(1).toBe(3),
      expect(2).toBe(1),
      expect(3).toBe(2),
    ]
  end function)

  it("should fail on try of checking calls of not mocked function", function (_ts as Object) as Object
    ' When
    functionCallingSum(1, 2)

    ' Then
    return [
      expect("sum").toHaveBeenCalledTimes(1),
      expect("sum").toHaveBeenCalledWith({ a: 1, b: 2 }),
    ]
  end function)

  it("should fail on try of getting proper function result if function is mocked", function (_ts as Object) as String
    ' When
    result = functionCallingDivide(6, 2)

    ' Then
    return expect(result).toBe(3)
  end function)

  it("should fail when try to compare arrays", function (_ts as Object) as String
    ' When
    expected = ["a"]
    result = expected

    ' Then
    return expect(result).toBe(expected)
  end function)

  it("should fail when try to compare associative arrays", function (_ts as Object) as String
    ' When
    expected = { a: 1 }
    result = expected

    ' Then
    return expect(result).toBe(expected)
  end function)

  it("should fail when illeagal operation is taken in the test", function (_ts as Object) as String
    ' When
    nonexistingfunction(6, 2)

    ' Then
    return expect(true).toBeTrue()
  end function)

  return ts
end function
