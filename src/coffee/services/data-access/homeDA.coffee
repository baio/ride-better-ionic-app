app.factory "homeDA", (homeEP, homeCache, $q, threadMapper) ->

  trimText = (text) ->
    if text?.length > 150 then text[0..149] + "..." else text

  mapHome = (home) ->
    home.reports ?= []
    home.latestImportant ?= []
    home.reports.map threadMapper.mapThread
    home.latestImportant.map threadMapper.mapThread
    home.snapshot.lastImportant = home.latestImportant[0]
    console.log "homeDA.coffee:12 >>>", home.snapshot.lastImportant
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