app.factory "cacheManager", (homeCache, boardCache) ->

  #need to instantiate this factory on app start in order to cache could catch all cache related events from the scratch

  ok : true