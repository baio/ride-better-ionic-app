app.factory "homeDA", (homeEP, homeCache, $q, threadMapper) ->

  trimText = (text) ->
    if text?.length > 150 then text[0..149] + "..." else text

  mapHome = (home) ->
    if home.snapshot.latestImportant
      home.snapshot.latestImportantShort = trimText home.snapshot.latestImportant
    home.reports ?= []
    home.latestImportant ?= []
    home.reports.map threadMapper.mapThread
    home.latestImportant.map threadMapper.mapThread
    console.log "homeDA.coffee:13 >>>", home
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