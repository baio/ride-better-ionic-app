app.factory "boardDA", (boardEP) ->
  get: boardEP.get
  postThread: boardEP.postThread
  putThread: boardEP.putThread
  removeThread: boardEP.removeThread
  getThread: boardEP.getThread
  postReply: boardEP.postReply
  removeReply: boardEP.removeReply

