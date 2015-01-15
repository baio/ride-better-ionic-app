app.factory "homeCache", ($rootScope, cache) ->

  getCacheName = -> "home-latest"

  console.log "homeCache.coffee:5 >>>" 

  $rootScope.$on "user::propertyChanged", (e, prms) ->
    console.log "homeCache.coffee:6 >>>"
    cache.rm getCacheName()

  console.log "homeCache.coffee:11 >>>"

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
