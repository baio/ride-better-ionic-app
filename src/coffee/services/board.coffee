app.factory "board", (boardDA, user, $ionicModal, notifier) ->

  msgModal = null
  board = null
  scope = null

  data = 
    currentThread : null
    canLoadMoreThreads : false
    canLoadMoreReplies : false
    threads : []

  setBoard = (res, index) ->
    if res
      if index is undefined
        data.threads.push res.threads...
      else
        data.threads.splice index, 0, res.threads...

  loadBoard = (opts, pushIndex) ->
    home = user.getHome()
    boardDA.get({spot : home.code, board : "faq"}, opts).then (res) -> 
      setBoard(res, pushIndex)

  setThread = (res, index) ->
    if res
      thread = res.thread
      thread.replies = []      
      if index is undefined
        thread.replies.push res.replies...
      else
        thread.replies.splice index, 0, res.replies...
      data.threads = [thread]
      data.currentThread = thread

  loadThread = (id, opts, pushIndex) ->
    home = user.getHome()
    boardDA.getThread(id, opts).then (res) ->
      setThread(res, pushIndex)

  # --- Send Message Form ---

  openMsgModal = (item, mode, type) ->
    user.login().then ->
      msgModal.opts = 
        type : type
        mode: mode
        item: item
      if mode == "edit"
        data.newMessage = item.text
      else
        data.newMessage = ""
      msgModal.show()

  loadMoreThreads = ->    
    last = data.threads[data.threads.length - 1]
    if last
      since = moment.utc(last.created, "X").unix()

    loadBoard(since : since).then (res) ->
      data.canLoadMoreThreads = res.hasMore
    .catch ->
      data.canLoadMoreThreads = false

  pullMoreThreads = ->
    first = data.threads[0]
    if first
      till = moment.utc(first.message.created, "X").unix()
    loadBoard(till : till, 0)

  getThread = (threadId) ->
    data.threads.filter((f) -> f._id == threadId)[0]

  loadMoreReplies = (threadId) ->    
    thread = getThread threadId
    if thread
      last = thread.replies[thread.replies.length - 1]
      if last
        since = moment.utc(last.created, "X").unix()

    loadThread(threadId, since : since).then (res) ->
      data.canLoadMoreReplies = res.hasMore
    .catch ->
      data.canLoadMoreReplies = false

  pullMoreReplies = (threadId) ->
    thread = getThread threadId
    if thread      
      first = thread.replies[0]
      if first
        till = moment.utc(first.message.created, "X").unix()

    loadThread(threadId, till : till, 0)

  resetData = ->
      data.currentThread = null
      data.canLoadMoreThreads = false
      data.canLoadMoreReplies = false      
      data.threads = []    
  # ----

  init: (scope, boardName, currentThread) -> 
    board = boardName
    resetData()
    if currentThread
      setThread currentThread
    $ionicModal.fromTemplateUrl('modals/sendMsgForm.html',
      scope : scope
      animation: 'slide-in-up'
    ).then (modal) ->
      msgModal = modal

  data : data

  loadMoreThreads : loadMoreThreads
  loadMoreReplies : loadMoreReplies
  pullMoreThreads : pullMoreThreads
  pullMoreReplies : pullMoreReplies

  canEdit : (item) ->
    user.isUser item.user

  removeThread : (thread) ->    
    notifier.confirm("After delete, item couldn't be restored. Delete?")
    .then (res) ->
      if res
        home = user.getHome().code
        boardDA.removeThread(thread._id)
    .then ->
      data.threads.splice data.threads.indexOf(thread), 1
      data.currentThread = null

  removeReply : (thread, reply) ->    
    notifier.confirm("After delete, item couldn't be restored. Delete?")
    .then (res) ->
      if res
        home = user.getHome().code
        boardDA.removeReply(reply._id)
    .then ->
      thread.replies.splice thread.replies.indexOf(reply), 1

  dispose: -> msgModal.remove()

  openThreadModal: (item, mode) ->
    console.log "board.coffee:138 >>>", item
    openMsgModal item, mode, "thread"

  openReplyModal: (item, mode) ->
    openMsgModal item, mode, "reply"

  sendMessage: ->
    if !data.newMessage
      notifier.message "Please input some text"
    else
      home = user.getHome().code
      opts = msgModal.opts
      d = message : data.newMessage
      promise = null
      if opts.type == "thread"
        if opts.mode == "create"
          promise = boardDA.postThread({spot : home, board : board}, d).then (res) -> 
            data.threads.splice 0, 0, res
        if opts.mode == "edit"
          promise = boardDA.putThread(opts.item._id, d).then ->
            opts.item.text = data.newMessage
      else if opts.type == "reply"
        if opts.mode == "create"
          promise = boardDA.postReply(opts.item._id, d).then (res) -> 
            opts.item.replies.splice 0, 0, res
        data.newMessage = ""
      promise?.then -> msgModal.hide()

  cancelMsgModal: ->
    msgModal.hide()
