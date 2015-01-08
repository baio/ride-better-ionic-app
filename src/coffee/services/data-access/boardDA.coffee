app.factory "boardDA", (boardEP) ->

  saveThread = (method, opts, data) ->    
    if !data.img or (!data.img.file and !data.img.url)
      data = angular.copy data
      if data.img
        imgSrc = data.img.src 
        delete data.img
        data.img = imgSrc
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

  get: boardEP.get  
  removeThread: boardEP.removeThread
  getThread: boardEP.getThread
  postReply: boardEP.postReply
  removeReply: boardEP.removeReply

