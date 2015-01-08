app.factory "boardEP", (_ep) ->

  get: (opts, prms) ->
    _ep.get "spots/#{opts.spot}/boards/#{opts.board}", prms

  postThread: (opts, data) ->
    _ep.post "spots/#{opts.spot}/boards/#{opts.board}/threads", data, true

  postThreadImg: (opts, file, data) ->
    _ep.postFile "spots/#{opts.spot}/boards/#{opts.board}/threads/img", file, data, true

  putThread: (threadId, data) ->
    _ep.put "spots/boards/threads/#{threadId}", data, true

  removeThread: (threadId) ->
    _ep.remove "spots/boards/threads/#{threadId}", true

  getThread: (threadId) ->
    _ep.get "spots/boards/threads/#{threadId}"

  postReply: (threadId, data) ->
    _ep.post "spots/boards/threads/#{threadId}/replies", data, true

  removeReply: (replyId, data) ->
    _ep.remove "spots/boards/threads/replies/#{replyId}", true

