' @import /components/KopytkoTestSuite.brs
function KopytkoFrameworkTestSuite() as Object
  ts = KopytkoTestSuite()

  ts._afterEach.push(sub (ts as Object)
    ts._clearComponent(m)
  end sub)

  ' "func as Function" crashes the app
  ts.createTest = function (name as String, func as Object, setup = invalid as Object, teardown = invalid as Object, arg = invalid as Dynamic, hasArgs = false as Boolean, skip = false as Boolean) as Object
    return {
      Name: name,
      _func: [func],
      Func: function () as String
        componentAA = GetGlobalAA()
        componentAA.global.removeField("eventBus")

        ' TestRunner runs this method within TestSuite context
        for each beforeEach in m._beforeEach
          if (TF_Utils__IsFunction(beforeEach))
            beforeEach(m)
          end if
        end for

        if (m.testInstance.hasArguments)
          result = m.testInstance._func[0](m, m.testInstance.arg)
        else
          result = m.testInstance._func[0](m)
        end if

        for each afterEach in m._afterEach
          if (TF_Utils__IsFunction(afterEach))
            afterEach(m)
          end if
        end for

        return result
      end function,
      _setUp: [setup],
      SetUp: sub ()
        ' TestRunner runs this method within TestCase context
        if (TF_Utils__IsFunction(m._setUp[0]))
          m._setUp[0](m.testSuite)
        end if

        componentInterface = GetGlobalAA().top
        ' Setting defaultProps only for Kopytko components because other components may have observers set in the init()
        ' function (should be avoided in Kopytko) and setting defaultProps after each test would call these callbacks
        if (componentInterface.isSubtype("KopytkoGroup"))
          m.testsuite._defaultProps = componentInterface.getFields()
          m.testsuite._defaultProps.delete("change")
          m.testsuite._defaultProps.delete("focusedChild")
        end if
      end sub,
      _tearDown: [teardown],
      TearDown: sub ()
        ' TestRunner runs this method within TestCase context
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

  ts.assertDataWasSetOnStore = function (data as Object, msg = "" as String) as String
    if (m.wasMethodCalled("StoreFacade.set", data)) then return ""
    if (msg <> "") then return msg

    return "The data was not set on store"
  end function

  ts.assertRequestWasMade = function (params as Object, options = {} as Object, msg = "" as String) as String
    if (m.wasMethodCalled("createRequest", params, options)) then return ""
    if (msg <> "") then return msg

    return "The request was not made the expected number of times with the given params"
  end function

  ts._clearComponent = sub (componentScope as Object)
    if (Type(destroyKopytko) <> "Invalid")
      destroyKopytko()
      componentScope.top.setFocus(true)

      ' Unobserving fields only of Kopytko components because non-kopytko may set up observers in the init() function
      ' which is called only once for all test cases
      for each field in componentScope.top.keys()
        componentScope.top.unobserveFieldScoped(field)
      end for
    end if

    if (componentScope["$$setTimeoutData"] <> Invalid)
      for each timeoutId in componentScope["$$setTimeoutData"]
        timeout = componentScope["$$setTimeoutData"][timeoutId]
        timeout.timer.unobserveFieldScoped("fire")
        timeout.timer.control = "stop"
        componentScope["$$setTimeoutData"].delete(timeoutId)
      end for
    end if
    if (componentScope["$$setIntervalData"] <> Invalid)
      for each intervalId in componentScope["$$setIntervalData"]
        interval = componentScope["$$setIntervalData"][intervalId]
        interval.timer.unobserveFieldScoped("fire")
        interval.timer.control = "stop"
        componentScope["$$setIntervalData"].delete(intervalId)
      end for
    end if

    if (m._defaultProps <> Invalid)
      componentScope.top.update(m._defaultProps)
    end if
  end sub

  return ts
end function
