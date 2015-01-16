app.factory "boardDA", (boardEP, $q, amCalendarFilter, amDateFormatFilter, boardCache, $rootScope, resources, user) ->

  trimText = (text) ->
    if text?.length > 300 then text[0..299] + "..." else text

  getThumb = (img) ->
    return "//wit.wurfl.io/w_350/#{img}"

  mapReply = (reply) ->
    reply.formatted =
      shortText : if reply.data.text then trimText(reply.data.text) 
      createdStr : amCalendarFilter(reply.created)
    reply

  userRequestStatus = (thread) ->
    if thread.requests
      userRequest = thread.requests.filter((f) -> f.user.key == user.getKey())[0]
      if userRequest
        if userRequest.accepted == true
          return "accepted"
        else if userRequest.accepted == false
          return "rejected"
        else
          return "requested"      

  mapThread = (thread) ->
    thread.formatted = 
      shortText : trimText(thread.data.text)
      createdStr : amCalendarFilter(thread.created)
      metaDateStrLong : if thread.data.meta?.date then amDateFormatFilter(thread.data.meta.date, 'dddd, MMMM Do YYYY, HH:00')
      thumb : if thread.data.img then getThumb thread.data.img
    if thread.tags.indexOf("transfer") != -1
      thread.formatted.transfer =
        title : resources.str(thread.data.meta.type) + " - " + resources.str(thread.data.meta.transport)
        requestStatus : userRequestStatus thread
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
      if res.length
        res = res.map mapThread      
        boardCache.put filterStr, res
      res

  getThread: (id, opts) ->
    thread = boardCache.getThread id
    if thread
      return $q.when thread
    boardEP.getThread(id, opts).then mapThread      

  removeThread: (thread) -> 
    boardEP.removeThread(thread._id).then (res) ->
      $rootScope.$broadcast "::board.thread.remove", thread : thread
      res      

  removeReply: boardEP.removeReply

  postReply: (threadId, data) -> boardEP.postReply(threadId, data).then mapReply
  putReply: (threadId, data) -> boardEP.putReply(threadId, data).then mapReply

  requestTransfer: (thread) -> 
    boardEP.requestTransfer(thread._id).then (res) ->
      thread.requests ?= []
      thread.requests.push res
      mapThread thread

  unrequestTransfer: (thread) -> 
    boardEP.unrequestTransfer(thread._id).then (res) ->
      thread.requests ?= []
      ix = thread.requests.indexOf thread.requests.filter((f) -> f.user.key == res.user.key)[0]
      if ix != -1
        thread.requests.splice ix, 1
      mapThread thread

  acceptTransferRequest: (threadId, userRequestId, f) ->
    boardEP.acceptTransferRequest(threadId, userRequestId, f)



