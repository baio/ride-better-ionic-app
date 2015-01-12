app.factory "boardDA", (boardEP, $q) ->

  _latestBoard = null

  trimText = (text) ->
    if text?.length > 300 then text[0..299] + "..." else text

  mapReply = (reply) ->
    reply.data.shortText = trimText(reply.data.text) if reply.data.text
    reply

  mapThread = (thread) ->
    thread.data.shortText = trimText(thread.data.text)
    for reply in thread.replies
      mapReply(reply)
    thread

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
      promise = boardEP[method + "Thread"] opts, data
    else      
      file = if data.img.url then data.img.url else data.img.file
      data = angular.copy data
      delete data.img      
      promise = boardEP[method + "ThreadImg"] opts, file, data
    promise.then mapThread

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
        res = res.map mapThread      
        _latestBoard = 
          filter : getFilterStr prms, opts
          res : res
      res

  getThread: (id, opts) ->
    if !opts and _latestBoard
      thread = _latestBoard.res.filter((f) -> f._id == id)[0]
      if thread
        return $q.when thread
    boardEP.getThread(id, opts).then mapThread      

  removeThread: boardEP.removeThread  
  removeReply: boardEP.removeReply

  postReply: (threadId, data) -> boardEP.postReply(threadId, data).then mapReply
  putReply: (threadId, data) -> boardEP.putReply(threadId, data).then mapReply


