' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework
' @mock /components/Math.brs
' @mock /components/sum.brs

function TestSuite__mockExamples() as Object
  ts = KopytkoTestSuite()
  ts.name = "Mock Examples"

  beforeEach(sub (_ts as Object)
    mockFunction("sum").returnValue(111)
  end sub)

  it("should return sum value passed in before each hook", function (_ts as Object) as String
    ' Then
    return expect(funcCallingSum()).toBe(111)
  end function)

  it("should be able to mock Math.multiply implementation", function (_ts as Object) as String
    ' When
    m.__expected = 222
    mockFunction("Math.multiply").implementation(function (_params as Object, context as Object) as Integer
      return context.__expected
    end function)

    ' Then
    return expect(funcCallingMultiply()).toBe(m.__expected)
  end function)

  it("should be able to mock Math.multiply return value", function (_ts as Object) as String
    ' When
    expected = 333
    mockFunction("Math.multiply").returnValue(expected)

    ' Then
    return expect(funcCallingMultiply()).toBe(expected)
  end function)

  it("should be able to mock Math.multiply error", function (_ts as Object) as String
    ' When
    expected = "Some mocked error"
    mockFunction("Math.multiply").throw(expected)

    ' Then
    return expect(funcCallingMultiply).toThrow(expected)
  end function)

  it("should be able to reset all previous mocks", function (_ts as Object) as String
    ' Given
    mockFunction("Math.multiply").returnValue(444)

    ' When
    mockFunction("Math.multiply").clear()

    ' Then
    return expect(funcCallingMultiply()).toBe(0)
  end function)

  ' This test needs to be at the bottom
  it("should clear all mock calls from previous tests", function (_ts as Object) as Object
    ' Then
    return [
      expect("Math.multiply").toHaveBeenCalledTimes(0),
      expect(mockFunction("Math.multiply").getCalls()).toEqual([]),
    ]
  end function)

  return ts
end function
