app.factory "cache", (DSCacheFactory) ->

  cache = DSCacheFactory("app-cache")

  _ver = "2"
  _disbale_cachce = false

  get: (name) ->
    if _disbale_cachce then return
    val = cache.get name
    if val and val._val
      if val._ver != _ver
        cache.remove name
        val._val = undefined
      else if val._expired
        expired = val._expired
        currTime = (new Date()).getTime()
        if expired <= currTime
          cache.remove name
          val._val = undefined
      val = val._val
    val

  put: (name, val, expired) ->
    if _disbale_cachce then return
    if expired
      if expired == "eod" or not isNaN(expired)
        if expired == "eod"
          exp = moment().endOf("day")
        else
          exp = moment().add(expired, "minutes")
        cache.put name, _val : val, _expired : exp.valueOf(), _ver : _ver
      else
        throw new Error("Not implemented")
    else
      cache.put name, _val : val, _ver : _ver

  clean: ->
    if _disbale_cachce then return
    cache.removeAll()

  rm: (name) ->
    if _disbale_cachce then return
    cache.remove name