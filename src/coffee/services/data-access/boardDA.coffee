app.factory "boardDA", (boardEP, $q, amCalendarFilter, amDateFormatFilter, boardCache, $rootScope) ->

  trimText = (text) ->
    if text?.length > 300 then text[0..299] + "..." else text

  getThumb = (img) ->
    return "//wit.wurfl.io/w_350/#{img}"

  mapReply = (reply) ->
    reply.formatted =
      shortText : if reply.data.text then trimText(reply.data.text) 
      createdStr : amCalendarFilter(reply.created)
    reply

  mapThread = (thread) ->
    thread.formatted = 
      shortText : trimText(thread.data.text)
      createdStr : amCalendarFilter(thread.created)
      metaDateStrLong : if thread.data.meta?.date then amDateFormatFilter(thread.data.meta.date, 'dddd, MMMM Do YYYY, HH:00')
      thumb : if thread.data.img then getThumb thread.data.img
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


