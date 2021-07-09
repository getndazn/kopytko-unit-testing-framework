function Mock(options as Object) as Dynamic
  if (options.methods <> Invalid OR options.properties <> Invalid)
    _mock = ObjectMock(options)
  else if (options.fields <> Invalid)
    _mock = NodeMock(options)
  else
    _mock = FunctionMock(options)
  end if

  m.__mocks[options.name].instance = _mock

  return _mock
end function

function FunctionMock(options as Object) as Dynamic
  name = options.name
  params = options.params
  if (params = Invalid)
    params = {}
  end if

  if (m.__mocks = Invalid)
    m.__mocks = {}
  end if

  if (m.__mocks[name] = Invalid)
    m.__mocks[name] = {}
  end if

  if (m.__mocks[name].calls = Invalid)
    m.__mocks[name].calls = []
  end if

  m.__mocks[name].calls.push({ params: params })

  if (m.__mocks[name].getReturnValue <> Invalid AND Type(m.__mocks[name].getReturnValue) = "roFunction")
    return m.__mocks[name].getReturnValue(params, m)
  end if

  returnValue = m.__mocks[name].returnValue
  returnValueType = options.returnValueType
  if (returnValue <> Invalid)
    return returnValue
  end if

  if (returnValueType = Invalid OR LCase(returnValueType) = "object")
    return Invalid
  else if (LCase(returnValueType) = "integer")
    return 0
  else if (LCase(returnValueType) = "float")
    return 0.0
  else if (LCase(returnValueType) = "string")
    return ""
  else if (LCase(returnValueType) = "boolean")
    return false
  end if
end function

function ObjectMock(options as Object) as Object
  prototype = {}

  prototype.testComponent = options.testComponent
  prototype.name = options.name
  prototype.methods = options.methods
  prototype.constructorParams = options.constructorParams

  if (options.testComponent.__mocks = Invalid)
    options.testComponent.__mocks = {}
  end if

  if (options.testComponent.__mocks[options.name] = Invalid)
    options.testComponent.__mocks[options.name] = {}
  end if

  mock = options.testComponent.__mocks[options.name]

  if (options.properties <> Invalid)
    prototype.append(options.properties)
  end if

  if (mock.properties <> Invalid)
    prototype.append(mock.properties)
  end if

  if (mock.constructorCalls = Invalid)
    mock.constructorCalls = []
  end if
  mock.constructorCalls.push({ params: options.constructorParams })

  for each methodName in options.methods
    prototype[methodName] = options.methods[methodName]
    prototype[methodName + "Mock"] = function (methodName as String, methodParams = {} as Object, returnValueType = "Object" as String) as Dynamic
      if (m.testComponent.__mocks[m.name] = Invalid)
        m.testComponent.__mocks[m.name] = {}
      end if

      if (m.testComponent.__mocks[m.name][methodName] = Invalid)
        m.testComponent.__mocks[m.name][methodName] = {}
      end if

      if (m.testComponent.__mocks[m.name][methodName].calls = Invalid)
        m.testComponent.__mocks[m.name][methodName].calls = []
      end if

      m.testComponent.__mocks[m.name][methodName].calls.push({ params: methodParams })

      if (m.testComponent.__mocks[m.name][methodName].getReturnValue <> Invalid AND type(m.testComponent.__mocks[m.name][methodName].getReturnValue) = "roFunction")
        return m.testComponent.__mocks[m.name][methodName].getReturnValue(methodParams, m.testComponent)
      end if

      returnValue = m.testComponent.__mocks[m.name][methodName].returnValue
      if (returnValue <> Invalid)
        return returnValue
      end if

      if (LCase(returnValueType) = "object")
        return Invalid
      else if (LCase(returnValueType) = "integer")
        return 0
      else if (LCase(returnValueType) = "float")
        return 0.0
      else if (LCase(returnValueType) = "string")
        return ""
      else if (LCase(returnValueType) = "boolean")
        return false
      end if
    end function
  end for

  return prototype
end function

function NodeMock(options as Object) as Object
  node = CreateObject("roSGNode", "Node")

  node.addFields(options.fields)

  if (options.name <> Invalid)
    if (m.__mocks = Invalid)
      m.__mocks = {}
    end if

    if (m.__mocks[options.name] = Invalid)
      m.__mocks[options.name] = {}
    end if

    if (m.__mocks[options.name].constructorCalls = Invalid)
      m.__mocks[options.name].constructorCalls = []
    end if

    m.__mocks[options.name].constructorCalls.push({ params: options.constructorParams })
  end if

  return node
end function
