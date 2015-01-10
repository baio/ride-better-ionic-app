app.factory "boardDA", (boardEP, $q) ->

  _latestBoard = null

  getFilterStr = (prms, opts) ->
    filter = filter :
        prms : prms 
        opts : opts
    JSON.stringify filter

  saveThread = (method, opts, data) ->    
    if !data.img or (!data.img.file and !data.img.url)
      data = angular.copy data
      if data.img and data.img.src
        imgSrc = data.img.src 
        delete data.img
        data.img = imgSrc
      else 
        delete data.img
      boardEP[method + "Thread"] opts, data
    else      
      file = if data.img.url then data.img.url else data.img.file
      data = angular.copy data
      delete data.img      
      boardEP[method + "ThreadImg"] opts, file, data

  postThread: (opts, data) ->
    saveThread "post", opts, data

  putThread: (opts, data) ->
    saveThread "put", opts, data

  get: (prms, opts) ->
    if _latestBoard      
      filterStr = getFilterStr prms, opts
      if _latestBoard.filter == filterStr
        return $q.when _latestBoard.res
    boardEP.get(prms, opts).then (res) ->
      if res.length
        _latestBoard = 
          filter : getFilterStr prms, opts
          res : res
      res

  getThread: (id, opts) ->
    if !opts and _latestBoard
      thread = _latestBoard.res.filter((f) -> f._id == id)[0]
      if thread
        return $q.when thread
    boardEP.getThread(id, opts)

  removeThread: boardEP.removeThread  
  postReply: boardEP.postReply
  putReply: boardEP.putReply
  removeReply: boardEP.removeReply

