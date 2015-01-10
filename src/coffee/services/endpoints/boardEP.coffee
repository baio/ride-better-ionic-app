app.factory "boardEP", (_ep) ->

  get: (opts, prms) ->
    url = "spots/#{opts.spot}/boards"
    url += "/#{opts.board}" if opts.board
    _ep.get url, prms

  postThread: (opts, data) ->
    _ep.post "spots/#{opts.spot}/boards/#{opts.board}/threads", data, true

  postThreadImg: (opts, file, data) ->
    _ep.postFile "spots/#{opts.spot}/boards/#{opts.board}/threads/img", file, data, true

  putThread: (threadId, data) ->
    _ep.put "spots/boards/threads/#{threadId}", data, true

  putThreadImg: (threadId, file, data) ->
    _ep.putFile "spots/boards/threads/#{threadId}/img", file, data, true

  removeThread: (threadId) ->
    _ep.remove "spots/boards/threads/#{threadId}", true

  getThread: (threadId, opts) ->
    _ep.get "spots/boards/threads/#{threadId}", opts

  postReply: (threadId, data) ->
    _ep.post "spots/boards/threads/#{threadId}/replies", data, true

  putReply: (replyId, data) ->
    _ep.put "spots/boards/threads/replies/#{replyId}", data, true

  removeReply: (replyId, data) ->
    _ep.remove "spots/boards/threads/replies/#{replyId}", true

