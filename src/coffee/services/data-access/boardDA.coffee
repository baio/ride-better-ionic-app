app.factory "boardDA", (boardEP) ->

  postThread: (opts, data) ->
    if !data.img.file and !data.img.url
      data = angular.copy data
      delete data.img
      boardEP.postThread opts, data
    else      
      file = if data.img.url then data.img.url else data.img.file
      data = angular.copy data
      delete data.img      
      boardEP.postThreadImg opts, file, data

  get: boardEP.get  
  putThread: boardEP.putThread
  removeThread: boardEP.removeThread
  getThread: boardEP.getThread
  postReply: boardEP.postReply
  removeReply: boardEP.removeReply

