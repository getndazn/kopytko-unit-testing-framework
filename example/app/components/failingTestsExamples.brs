' @import /components/sum.brs
' @import /components/divide.brs

function functionCallingSum(a as Integer, b as Integer) as Integer
  return sum(a, b)
end function

function functionCallingDivide(a as Integer, b as Integer) as Integer
  return divide(a, b)
end function
