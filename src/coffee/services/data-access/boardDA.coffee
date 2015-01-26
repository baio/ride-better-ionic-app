app.factory "boardDA", (boardEP, $q, $rootScope, threadMapper, threadsPoolService) ->

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
    
    promise.then threadsPoolService.push

  postThread: (opts, data) ->
    saveThread("post", opts, data)

  putThread: (opts, data) ->
    saveThread "put", opts, data

  get: (prms, opts) ->
    boardEP.get(prms, opts).then (res) ->
      threadsPoolService.push res

  getThread: (id, opts) ->
    existed = threadsPoolService.get id
    if existed then return $q.when existed
    boardEP.getThread(id, opts).then threadsPoolService.push

  removeThread: (thread) -> 
    boardEP.removeThread(thread._id)

  requestTransfer: (thread) -> 
    boardEP.requestTransfer(thread._id).then (res) ->
      thread.requests ?= []
      thread.requests.push res
      threadsPoolService.push res

  unrequestTransfer: (thread) -> 
    boardEP.unrequestTransfer(thread._id).then (res) ->
      thread.requests ?= []
      ix = thread.requests.indexOf thread.requests.filter((f) -> f.user.key == res.user.key)[0]
      if ix != -1
        thread.requests.splice ix, 1
      threadsPoolService.push res


  acceptTransferRequest: (thread, userRequest, f) ->
    boardEP.acceptTransferRequest(thread._id, userRequest.user.key, f).then ->
      userRequest.state = if f then "accepted" else "rejected"
      threadsPoolService.push thread      

  removeReply: (reply, thread) ->
    boardEP.removeReply(reply._id).then ->
      thread.replies.splice thread.replies.indexOf(reply), 1
      threadsPoolService.push thread      

  postReply: (thread, data) -> 
    boardEP.postReply(thread._id, data).then (res) ->
      thread.replies.splice 0, 0, threadMapper.mapReply res
      threadsPoolService.push thread      
  
  putReply: (reply, thread, data) ->
    boardEP.putReply(reply._id, data).then (res) ->      
      reply.data.text = data.message
      threadsPoolService.push thread    



