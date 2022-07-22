' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @mock /components/divide.brs

function TestSuite__Math() as Object
  ts = KopytkoTestSuite()
  ts.name = "Example - function returning object"

  it("should return a proper value for multiply", function (_ts as Object) as String
    ' When
    result = Math().multiply(3, 4)

    ' Then
    return expect(result).toBe(12)
  end function)

  it("should properly invoke and return a mocked divide return value", function (_ts as Object) as Object
    ' Given
    expected = 100
    mockFunction("divide").returnValue(expected)

    ' When
    result = Math().divide(6, 3)

    ' Then
    return [
      expect("divide").toHaveBeenCalledTimes(1),
      expect("divide").toHaveBeenCalledWith({ valueA: 6, valueB: 3 }),
      expect(result).toBe(expected),
    ]
  end function)

  return ts
end function
