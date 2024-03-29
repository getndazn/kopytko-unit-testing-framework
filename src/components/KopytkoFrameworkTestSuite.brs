' @import /components/KopytkoTestSuite.brs
function KopytkoFrameworkTestSuite() as Object
  ts = KopytkoTestSuite()

  #if insertKopytkoUnitTestSuiteArgument
    ts._beforeAll.push(sub (ts as Object)
      componentInterface = GetGlobalAA().top
      ' Setting defaultProps only for Kopytko components because other components may have observers set in the init()
      ' function (should be avoided in Kopytko) and setting defaultProps after each test would call these callbacks
      if (componentInterface.isSubtype("KopytkoGroup"))
        ts._defaultProps = componentInterface.getFields()
        ts._defaultProps.delete("change")
        ts._defaultProps.delete("focusedChild")
      end if
    end sub)

    ts._beforeEach.push(sub (ts as Object)
      componentAA = GetGlobalAA()
      componentAA.global.removeField("eventBus")
    end sub)

    ts._afterEach.push(sub (ts as Object)
      ts._clearComponent(m)
    end sub)
  #else
    ts._beforeAll.push(sub ()
      componentInterface = GetGlobalAA().top
      ' Setting defaultProps only for Kopytko components because other components may have observers set in the init()
      ' function (should be avoided in Kopytko) and setting defaultProps after each test would call these callbacks
      if (componentInterface.isSubtype("KopytkoGroup"))
        ts = GetGlobalAA()["$$ts"]
        ts._defaultProps = componentInterface.getFields()
        ts._defaultProps.delete("change")
        ts._defaultProps.delete("focusedChild")
      end if
    end sub)

    ts._beforeEach.push(sub ()
      componentAA = GetGlobalAA()
      componentAA.global.removeField("eventBus")
    end sub)

    ts._afterEach.push(sub ()
      ts = GetGlobalAA()["$$ts"]
      ts._clearComponent(m)
    end sub)
  #end if

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
