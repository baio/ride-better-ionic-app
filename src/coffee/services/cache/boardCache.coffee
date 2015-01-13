app.factory "boardCache", ($rootScope) ->

  _latestBoard = null

  $rootScope.$on "::board.thread.add", (e, prms) ->
    thread = prms.thread
    console.log "boardCache.coffee:7 >>>", prms
    _latestBoard.res.splice 0, 0, thread    

  $rootScope.$on "::board.thread.remove", (e, prms) ->
    thread = prms.thread
    console.log "boardCache.coffee:12 >>>", prms
    _latestBoard.res.splice _latestBoard.res.indexOf(thread), 1

  put: (filter, res) ->
    _latestBoard = 
      filter : filter
      res : res

  get: (filter) ->
    if _latestBoard?.filter == filter
      _latestBoard.res



