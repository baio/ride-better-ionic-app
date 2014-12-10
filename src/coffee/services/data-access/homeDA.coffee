app.factory "homeDA", (homeEP, cache, $q) ->

  _resetNext = false
  getCacheName = (opts) -> "home_" + opts.spot + "_" + opts.lang + "_" + opts.culture

  resetNext: -> _resetNext = true

  get : (opts) ->
    cacheName = getCacheName opts
    if _resetNext
      cache.rm cacheName
      _resetNext = false
    else
      cached = cache.get cacheName
    if cached      
      $q.when cached
    else
      homeEP.get(opts).then (res) ->
        cache.put cacheName, res, 5
        res