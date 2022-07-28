' @import /components/_testUtils/getProperty.brs
' @import /components/_testUtils/getType.brs
' @import /components/_testUtils/NodeUtils.brs
' @import /components/_testUtils/ternary.brs
' @import /components/KopytkoExpect.brs
' @import /components/KopytkoMockFunction.brs
' @import /components/KopytkoTestFunctions.brs
' @import /source/UnitTestFramework.brs

function KopytkoTestSuite() as Object
  ts = BaseTestSuite()
  GetGlobalAA()["$$ts"] = ts

  ts._ERROR_MESSAGE_LINE_BREAK = Chr(10) + "---                  "

  ' @protected
  ts._beforeAll = []
  ' @protected
  ts._afterAll = []
  ' @protected
  ts._beforeEach = []
  ' @protected
  ts._afterEach = []

  #if insertKopytkoUnitTestSuiteArgument
    ts._beforeEach.push(sub (_ts as Object)
      m.__mocks = {}
    end sub)
  #else
    ts._beforeEach.push(sub ()
      m.__mocks = {}
    end sub)
  #end if

  ts.setUp = sub ()
    for each _beforeAll in m._beforeAll
      if (TF_Utils__IsFunction(beforeAll))
        #if insertKopytkoUnitTestSuiteArgument
          _beforeAll(m)
        #else
          _beforeAll()
        #end if
      end if
    end for
  end sub

  ts.tearDown = sub ()
    for each _afterAll in m._afterAll
      if (TF_Utils__IsFunction(afterAll))
        #if insertKopytkoUnitTestSuiteArgument
          _afterAll(m)
        #else
          _afterAll()
        #end if
      end if
    end for
  end sub

  ts.addParameterizedTests = sub (paramsList as Object, testName as String, testFunction as Function)
    for each param in paramsList
      parsedTestName = testName

      if (Type(param) = "roAssociativeArray")
        for each item in param.items()
          value = item.value
          if (GetInterface(value, "ifToStr") <> Invalid)
            regex = CreateObject("roRegex", "\${" + item.key +"}", "i")
            parsedTestName = regex.replaceAll(parsedTestName, Box(value).toStr())
          end if
        end for
      else if (GetInterface(Box(param), "ifToStr") <> Invalid)
        parsedTestName = Substitute(parsedTestName, Box(param).toStr())
      else
        parsedTestName = Substitute(parsedTestName, "")
      end if

      m.addTest(parsedTestName, testFunction, Invalid, Invalid, param, true)
    end for
  end sub

  ' "func as Function" crashes the app
  ts.createTest = function (name as String, func as Object, setup = invalid as Object, teardown = invalid as Object, arg = invalid as Dynamic, hasArgs = false as Boolean, _skip = false as Boolean) as Object
    return {
      Name: name,
      _func: [func],
      Func: function () as String
        ' TestRunner runs this method within TestSuite context
        for each _beforeEach in m._beforeEach
          if (TF_Utils__IsFunction(_beforeEach))
            #if insertKopytkoUnitTestSuiteArgument
              _beforeEach(m)
            #else
              _beforeEach()
            #end if
          end if
        end for

        try
          if (m.testInstance.hasArguments)
            #if insertKopytkoUnitTestSuiteArgument
              result = m.testInstance._func[0](m, m.testInstance.arg)
            #else
              result = m.testInstance._func[0](m.testInstance.arg)
            #end if
          else
            #if insertKopytkoUnitTestSuiteArgument
              result = m.testInstance._func[0](m)
            #else
              result = m.testInstance._func[0]()
            #end if
          end if
        catch e
          sourceObj = e.backtrace[e.backtrace.count() - 1]
          result = Substitute("{0} at {1}", e.message, FormatJson(sourceObj))
        end try

        for each _afterEach in m._afterEach
          if (TF_Utils__IsFunction(_afterEach))
            #if insertKopytkoUnitTestSuiteArgument
              _afterEach(m)
            #else
              _afterEach()
            #end if
          end if
        end for

        if (Type(result) = "roArray")
          if (result.join("") <> "")
            notPassedResults = []

            for each assertResult in result
              if (assertResult <> "") then notPassedResults.push(assertResult)
            end for

            result = notPassedResults.join(m._ERROR_MESSAGE_LINE_BREAK)
          else
            result = ""
          end if
        end if

        return result
      end function,
      _setUp: [setup],
      SetUp: sub ()
        if (TF_Utils__IsFunction(m._setUp[0]))
          m._setUp[0](m.testSuite)
        end if
      end sub,
      _tearDown: [teardown],
      TearDown: sub ()
        if (TF_Utils__IsFunction(m._tearDown[0]))
          m._tearDown[0](m.testSuite)
        end if
      end sub,
      perfData: {},
      testSuite: m,
      hasArguments: hasArgs,
      arg: arg,
    }
  End Function

  ts.setBeforeAll = sub (callback as Function)
    m._beforeAll.push(callback)
  end sub

  ts.setBeforeEach = sub (callback as Function)
    m._beforeEach.push(callback)
  end sub

  ts.setAfterEach = sub (callback as Function)
    m._afterEach.push(callback)
  end sub

  ts.setAfterAll = sub (callback as Function)
    m._afterAll.push(callback)
  end sub

  ts.findLabelByText = function (query as String, container = Invalid as Object) as Object
    splitRegExp = query.split("/")

    if (splitRegExp.count() = 3)
      regExp = CreateObject("roRegex", splitRegExp[1], splitRegExp[2])
    else
      regExp = CreateObject("roRegex", query, "g")
    end if

    if (container = Invalid)
      container = getGlobalAA().top
    end if

    return m._getByTextIterator(regExp, container)
  end function

  ''''''''''''''''''''''
  ' Custom assertions: '
  ''''''''''''''''''''''
  ts.assertNodesAreEqual = function (expected as Object, tested as Object, msg = "" as String) as String
    expectedType = Type(Box(expected), 3)
    testedType = Type(Box(tested), 3)
    result = m.assertEqual(expectedType, testedType, msg)

    if (expectedType <> "roSGNode" OR result <> "")
      return result
    end if

    result = m.assertEqual(expected.getFields(), tested.getFields(), msg)

    if (result <> "")
      return result
    end if

    result = m.assertEqual(expected.getChildCount(), tested.getChildCount(), msg)

    if (result <> "")
      return result
    end if

    for i = 0 to expected.getChildCount() - 1
      expectedItem = expected.getChild(i)
      testedItem = tested.getChild(i)
      result = m.assertNodesAreEqual(expectedItem, testedItem, msg)

      if (result <> "")
        return result
      end if
    end for

    return m.assertEqual(expected.parentSubtype(expected.subtype()), tested.parentSubtype(tested.subtype()), msg)
  end function

  ts.assertMethodWasCalled = function (methodPath as String, params = {} as Object, options = {} as Object, msg = "" as String) as String
    if (m.wasMethodCalled(methodPath, params, options)) then return ""
    if (msg <> "") then return msg

    return "The method was not called the expected number of times with the given params"
  end function

  ts.assertMethodWasNotCalled = function (methodPath as String, params = {} as Object, options = {} as Object, msg = "" as String) as String
    options.times = 0
    if (m.wasMethodCalled(methodPath, params, options)) then return ""
    if (msg <> "") then return msg

    return "The method was called"
  end function

  ''''''''''
  ' Utils: '
  ''''''''''
  ts.wasMethodCalled = function (methodPath as String, expectedParams = {} as Object, options = {} as Object) as Boolean
    expectedCallsCount = options.times
    isStrict = (options.strict <> Invalid AND options.strict)
    actualCallsCount = 0
    methodMock = m.getProperty(GetGlobalAA().__mocks, methodPath, { calls: [] })

    if (expectedParams = Invalid)
      expectedParams = {}
    end if

    if (expectedCallsCount = Invalid)
      expectedCallsCount = -1
    end if

    for each methodCall in methodMock.calls
      if (isStrict AND m.eqValues(methodCall.params, expectedParams))
        if (expectedCallsCount = -1)
          return true
        end if

        actualCallsCount++
      else if (m.isMatch(methodCall.params, expectedParams))
        if (expectedCallsCount = -1)
          return true
        end if

        actualCallsCount++
      end if
    end for

    if (expectedCallsCount = -1)
      return false
    end if

    return (expectedCallsCount = actualCallsCount)
  end function

  ts.isMatch = function (valueA as Dynamic, valueB as Dynamic) as Boolean
    if (Type(valueA) = "roSGNode") then valueA = valueA.getFields()
    if (Type(valueB) = "roSGNode") then valueB = valueB.getFields()

    if (Type(Box(valueA), 3) <> Type(Box(valueB), 3))
      return false
    end if

    valuesType = Type(valueA)

    if (valuesType = "roArray")
      for i = 0 to valueB.count() - 1
        if (NOT m.isMatch(valueA[i], valueB[i]))
          return false
        end if
      end for

      return true
    end if

    if (valuesType = "roAssociativeArray")
      for each key in valueB
        if (NOT m.isMatch(valueA[key], valueB[key]))
          return false
        end if
      end for

      return true
    end if

    return (valueA = valueB)
  end function

  ' Copied from codebase since we can't have dependencies in test framework
  ts.getProperty = kopytkoUnitTestingFramework__getProperty
  ts.getType = kopytkoUnitTestingFramework__getType
  ts.NodeUtils = kopytkoUnitTestingFramework__NodeUtils
  ts.ternary = kopytkoUnitTestingFramework__ternary

  ts._getByTextIterator = function (regExp as Object, container as Object) as Object
    childCount = container.getChildCount()
    for i = 0 to childCount - 1
      element = container.getChild(i)

      if (element.getSubtype() = "Label" OR element.getSubtype() = "SimpleLabel")
        if (regExp.match(element.text).count() >= 1)
          return element
        end if
      end if

      element = m._getByTextIterator(regExp, element)
      if (element <> Invalid)
        return element
      end if
    end for

    return Invalid
  end function

  return ts
end function
