app.factory "homeDA", (homeEP, cache, $q) ->

  _resetNext = false
  getCacheName = (spot, lang) -> "home_" + spot + "_" + lang

  resetNext: -> _resetNext = true

  get : (spot, lang) ->
    cacheName = getCacheName spot, lang
    if _resetNext
      cache.rm cacheName
      _resetNext = false
    else
      cached = cache.get cacheName
    if cached
      $q.when cached
    else
      homeEP.get(spot, lang).then (res) ->
        cache.put cacheName, res, 5
        res