function fakeClock(scope as Object)
  prototype = {}

  prototype._scope = scope

  prototype._FLOAT_PRECISION = 0.00001

  _constructor = function (m as Object) as Object
    m._scope.__currentTime = 0
    m._scope["$$setIntervalData"] = {}
    m._scope["$$setTimeoutData"] = {}

    return m
  end function

  prototype.tick = sub (time = 0 as Float)
    m._scope.__currentTime += time

    itemToCall = m._getNextItemToCall()
    while (itemToCall <> Invalid)
      if (itemToCall.timer.nextCall <> Invalid)
        itemToCall.timer.nextCall += itemToCall.timer.duration
        itemToCall.timer.fire = itemToCall.timer.nextCall
      end if

      itemToCall = m._getNextItemToCall()
    end while
  end sub

  prototype._getNextItemToCall = function () as Object
    itemsToCall = []

    for each intervalId in m._scope["$$setIntervalData"]
      interval = m._scope["$$setIntervalData"][intervalId]

      if (interval.timer.nextCall <= m._scope.__currentTime + m._FLOAT_PRECISION)
        interval.callTime = interval.timer.nextCall
        itemsToCall.push(interval)
      end if
    end for

    for each timeoutId in m._scope["$$setTimeoutData"]
      timeout = m._scope["$$setTimeoutData"][timeoutId]

      if (timeout.timer.duration <= m._scope.__currentTime + m._FLOAT_PRECISION)
        timeout.callTime = timeout.timer.duration
        itemsToCall.push(timeout)
      end if
    end for

    itemsToCall.sortBy("callTime")

    return itemsToCall[0]
  end function

  return _constructor(prototype)
end function
