app.factory "cache", (DSCacheFactory) ->

  cache = DSCacheFactory("app-cache")

  _ver = "1"

  get: (name) ->
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

  rm: (name) -> cache.remove name

  clean: -> cache.removeAll()

  replace: (coll, name, val) ->
    @pop coll, name
    @push coll, name, val

  push: (coll, name, val) ->
    if !@get coll + "." + name
      @put coll + "." + name, val
      true
    else
      false

  pop: (coll, name) ->
    @rm coll + "." + name

  item: (coll, name) ->
    @get coll + "." + name

  all: (coll) ->
    @get(key) for key in cache.keys().filter (f) -> f.indexOf(coll + ".") == 0


