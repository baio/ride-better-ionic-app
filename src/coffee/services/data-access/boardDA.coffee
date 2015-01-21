app.factory "boardDA", (boardEP, $q, boardCache, $rootScope, threadMapper) ->


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
    promise.then threadMapper.mapThread

  postThread: (opts, data) ->
    saveThread("post", opts, data).then (res) ->
      $rootScope.$broadcast "::board.thread.add", thread : res
      res

  putThread: (opts, data) ->
    saveThread "put", opts, data

  get: (prms, opts) ->
    filterStr = getFilterStr prms, opts
    cached = boardCache.get filterStr
    if cached
      return $q.when cached
    boardEP.get(prms, opts).then (res) ->
      res = res.map threadMapper.mapThread      
      boardCache.put filterStr, res
      res

  getThread: (id, opts) ->
    thread = boardCache.getThread id
    if thread
      return $q.when thread
    boardEP.getThread(id, opts).then threadMapper.mapThread      

  removeThread: (thread) -> 
    boardEP.removeThread(thread._id).then (res) ->
      $rootScope.$broadcast "::board.thread.remove", thread : thread
      res      

  removeReply: boardEP.removeReply

  postReply: (threadId, data) -> boardEP.postReply(threadId, data).then threadMapper.mapReply
  putReply: (threadId, data) -> boardEP.putReply(threadId, data).then threadMapper.mapReply

  requestTransfer: (thread) -> 
    boardEP.requestTransfer(thread._id).then (res) ->
      thread.requests ?= []
      thread.requests.push res
      threadMapper.mapThread thread

  unrequestTransfer: (thread) -> 
    boardEP.unrequestTransfer(thread._id).then (res) ->
      thread.requests ?= []
      ix = thread.requests.indexOf thread.requests.filter((f) -> f.user.key == res.user.key)[0]
      if ix != -1
        thread.requests.splice ix, 1
      threadMapper.mapThread thread

  acceptTransferRequest: (threadId, userRequestId, f) ->
    boardEP.acceptTransferRequest(threadId, userRequestId, f)



