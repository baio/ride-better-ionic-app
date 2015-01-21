app.factory "homeDA", (homeEP, homeCache, $q) ->

  trimText = (text) ->
    if text?.length > 150 then text[0..149] + "..." else text

  mapHome = (home) ->
    if home.snapshot.latestImportant
      home.snapshot.latestImportant.shortText = trimText home.snapshot.latestImportant.data.text
    home

  get : (opts) ->
    cachedHome = homeCache.get(opts.spot)
    if cachedHome    
      $q.when cachedHome
    else
      homeEP.get(opts).then (res) ->
        res = mapHome res
        homeCache.put opts.spot, res
        res