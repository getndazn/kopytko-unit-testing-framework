function mockFunction(functionName as String) as Object
  _globalAA = GetGlobalAA()
  context = {}
  context._functionName = functionName
  context._ts = _globalAA["$$ts"]

  if (_globalAA["__mocks"] = Invalid)
    _globalAA["__mocks"] = {}
  end if

  context._mock = _globalAA["__mocks"]
  for each part in functionName.split(".")
    if (context._mock[part] = Invalid)
      context._mock[part] = {}
    end if

    context._mock = context._mock[part]
  end for

  ' ----------------------------------------------------------------
  ' To clear mock settings and calls
  ' ----------------------------------------------------------------
  context.clear = sub ()
    m._mock.clear()
  end sub

  ' ----------------------------------------------------------------
  ' Returns mock calls
  '
  ' @return An array with function calls
  ' ----------------------------------------------------------------
  context.getCalls = function () as Object
    return m._ts.getProperty(GetGlobalAA()["__mocks"], m._functionName + ".calls", [])
  end function

  ' ----------------------------------------------------------------
  ' [DEPRECATED] This method name has been misspelled and will be removed in the future
  ' Returns mock constructor calls
  '
  ' @return An array with function calls
  ' ----------------------------------------------------------------
  context.getContructorCalls = function () as Object
    print "getContructorCalls is DEPRECATED, please use correct version - getConstructorCalls"

    return m._ts.getProperty(GetGlobalAA()["__mocks"], m._functionName + ".constructorCalls", [])
  end function

  ' ----------------------------------------------------------------
  ' Returns mock constructor calls
  '
  ' @return An array with function constructor calls
  ' ----------------------------------------------------------------
  context.getConstructorCalls = function () as Object
    return m._ts.getProperty(GetGlobalAA()["__mocks"], m._functionName + ".constructorCalls", [])
  end function

  ' ----------------------------------------------------------------
  ' Mocks function implementation
  '
  ' @param func (function) - Function implementation
  ' This function has 2 params
  ' - params - object where keys are argument names used in original implementation
  ' - context - context of the test suite, where you can store some data hany in the funciton implementation
  ' ----------------------------------------------------------------
  context.implementation = sub (func as Function)
    m._mock.getReturnValue = func
  end sub

  ' ----------------------------------------------------------------
  ' Mocks function return value
  '
  ' @param value (dynamic) - Expected value
  ' ----------------------------------------------------------------
  context.returnValue = sub (value as Dynamic)
    m._mock.returnValue = value
  end sub

  ' ----------------------------------------------------------------
  ' Mocks function resolved value
  '
  ' @param value (dynamic) - Expected value
  ' ----------------------------------------------------------------
  context.resolvedValue = sub (value as Dynamic)
    if (PromiseResolve <> Invalid)
      m._mock.returnValue = PromiseResolve(value)
    else
      error = [
        "To mock resolvedValue you need to import PromiseResolve from @dazn/kopytko-utils in your test",
        "Please add the following line to your test",
        "' @import /components/promise/PromiseResolve.brs from @dazn/kopytko-utils",
      ]
      throw error.join(Chr(10))
    end if
  end sub

  ' ----------------------------------------------------------------
  ' Mocks function rejected value
  '
  ' @param error (dynamic) - Expected error
  ' ----------------------------------------------------------------
  context.rejectedValue = sub (error as Dynamic)
    if (PromiseReject <> Invalid)
      m._mock.returnValue = PromiseReject(error)
    else
      error = [
        "To mock rejectedValue you need to import PromiseReject from @dazn/kopytko-utils in your test",
        "Please add the following line to your test",
        "' @import /components/promise/PromiseReject.brs from @dazn/kopytko-utils",
      ]
      throw error.join(Chr(10))
    end if
  end sub

  ' ----------------------------------------------------------------
  ' Mocks function set of properties
  '
  ' @param properties (object) - Properties Associative Array
  ' ----------------------------------------------------------------
  context.setProperties = sub (properties as Object)
    if (m._mock.properties = Invalid)
      m._mock.properties = {}
    end if

    m._mock.properties.append(properties)
  end sub

  ' ----------------------------------------------------------------
  ' Mocks function property
  '
  ' @param name (string) - Property name
  ' @param value (dynamic) - Property value
  ' ----------------------------------------------------------------
  context.setProperty = sub (name as String, value as Dynamic)
    if (m._mock.properties = Invalid)
      m._mock.properties = {}
    end if

    m._mock.properties[name] = value
  end sub

  ' ----------------------------------------------------------------
  ' Mocks function exception
  '
  ' @param error (dynamic) - Expected error String or Object
  ' https://developer.roku.com/docs/references/brightscript/language/error-handling.md#throwing-exceptions
  ' ----------------------------------------------------------------
  context.throw = sub (error as Dynamic)
    m._mock["$$errorToThrow"] = error
    m._mock.getReturnValue = function (_params as Object, _m as Object) as Dynamic
      throw m["$$errorToThrow"]
    end function
  end sub

  return context
end function
