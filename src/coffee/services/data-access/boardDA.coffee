app.factory "boardDA", (boardEP) ->

  get: boardEP.get
  postThread: boardEP.postThread
  postReply: boardEP.postReply
  removeThread: boardEP.removeThread
  getThread: boardEP.getThread

