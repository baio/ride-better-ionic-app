app.factory "homeCache", ($rootScope, cache) ->

  getCacheName = -> "home-latest"

  $rootScope.$on "::user::propertyChanged", ->
    cache.rm getCacheName()

  $rootScope.$on "::board.thread.add", (e, prms) ->
    console.log "homeCache.coffee:9 >>>", prms
    if prms.thread.tags.indexOf("report") != -1      
      cache.rm getCacheName()

  $rootScope.$on "::board.thread.remove", (e, prms) ->
    if prms.thread.tags.indexOf("report") != -1
      console.log "homeCache.coffee:13 >>>", "remove" 
      cache.rm getCacheName()
    
  put: (spot, val) ->
    cache.put getCacheName(), {spot : spot, val : val}, 5

  get: (spot) ->
    cached = cache.get getCacheName()
    console.log "homeCache.coffee:19 >>>", cached
    if cached?.spot == spot
      cached.val
