' @import /components/Math.brs
' @import /components/sum.brs

function funcWithException()
  throw "dummy exception!"
end function

function funcWithNoException()
end function

function funcCallingSum(aValue = 1 as Integer, bValue = 2 as Integer) as Integer
  return sum(aValue, bValue)
end function

function funcCallingMultiply(aValue = 1 as Integer, bValue = 2 as Integer) as Integer
  return Math().multiply(aValue, bValue)
end function

function funcReturningPi() as Float
  return Math().Pi
end function

function funcReturningTau() as Float
  return Math().Tau
end function

function funcNotCallingSum()
end function
