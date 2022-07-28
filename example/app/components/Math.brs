' @import /components/divide.brs

function Math() as Object
  prototype = {}

  prototype.multiply = function (valueA as Integer, valueB as Integer) as Integer
    return valueA * valueB
  end function 

  prototype.divide = divide

  return prototype
end function
