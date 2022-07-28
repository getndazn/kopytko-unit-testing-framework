' @import /components/sum.brs

sub funcWithException()
  throw "dummy exception!"
end sub

sub funcWithNoException()
end sub

function funcCallingSum(aValue = 1 as Integer, bValue = 2 as Integer) as Integer
  return sum(aValue, bValue)
end function

sub funcNotCallingSum()
end sub
