' @import /components/sum.brs

function funcWithException()
    throw "dummy exception!"
end function

function funcWithNoException()
end function

function funcCallingSum(aValue = 1 as Integer, bValue = 2 as Integer)
    value = sum(aValue, bValue)
end function

function funcNotCallingSum()
end function
