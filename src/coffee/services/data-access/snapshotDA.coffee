app.factory "snapshotDA", (snapshotEP, cache, $q) ->

  get : (spot, lang) ->
    cacheName = spot + "_" + lang
    cached = cache.get cacheName
    if cached
      $q.when cached
    else
      snapshotEP.get(spot, lang).then (res) ->
        cache.put cacheName, res, 5
        res