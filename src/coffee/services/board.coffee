app.factory "board", (boardDA, user, $ionicModal, notifier) ->

  _opts = {}
  _defOpts = 
    board :
      threadModal : null
      replyModal : null
      boardName : null
      spot : null
    thread :
      modalTemplate : "modals/sendMsgForm.html"
      map2send: (data) -> 
        message : data.newMessage        
      data2item: (item, data) ->
        item.text = data.newMessage
      item2data: (item, data) ->
        data.newMessage = item.text
      validate: (data) ->
        if !data.newMessage
          "Please input some text"
    reply: 
      modalTemplate : "modals/sendMsgForm.html"
      map2send: (data) -> 
        message : data.newMessage        
      data2item: (item, data) ->
        item.text = data.newMessage
      item2data: (item, data) ->
        data.newMessage = item.text
      validate: (data) ->
        if !data.newMessage
          "Please input some text"      

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
    boardDA.get({spot : _opts.board.spot, board : _opts.board.boardName}, opts).then (res) -> 
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
      msgModal = if type == "thread" then _opts.board.threadModal else _opts.board.replyModal
      msgModal.opts = 
        type : type
        mode: mode
        item: item
      if mode == "edit"
        _opts[type].item2data item, data
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

  getShownModal = ->
    if _opts.board.threadModal.isShown() then _opts.board.threadModal else _opts.board.replyModal      
  # ----

  init: (spt, scope, boardName, currentThread, opts) ->  
    angular.copy _defOpts, _opts
    if _opts.board.threadModal
      @dispose()
    if opts?.thread
      _opts.thread = opts.thread
    if opts?.reply
      _opts.reply = opts.reply
    _opts.board.spot = spt
    _opts.board.boardName = boardName
    resetData()
    if currentThread
      setThread currentThread
    $ionicModal.fromTemplateUrl(_opts.thread.modalTemplate,
      scope : scope
      animation: 'slide-in-up'
    ).then (modal1) ->
      _opts.board.threadModal = modal1
    $ionicModal.fromTemplateUrl(_opts.reply.modalTemplate,
      scope : scope
      animation: 'slide-in-up'
    ).then (modal2) ->
      _opts.board.replyModal = modal2

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
    .then (res) ->
      if res
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

  dispose: -> 
    _opts.board.threadModal.remove()
    _opts.board.replyModal.remove()
    _opts.board.threadModal = null
    _opts.board.replyModal = null

  openThreadModal: (item, mode) ->
    openMsgModal item, mode, "thread"

  openReplyModal: (item, mode) ->
    openMsgModal item, mode, "reply"

  sendMessage: ->
    msgModal = getShownModal()
    opts = msgModal.opts
    modalOpts = _opts[opts.type]
    err = modalOpts.validate data
    if err
      notifier.message err
    else
      home = _opts.board.spot
      d = modalOpts.map2send data
      promise = null
      if opts.type == "thread"
        if opts.mode == "create"
          promise = boardDA.postThread({spot : home, board : _opts.board.boardName}, d).then (res) -> 
            data.threads.splice 0, 0, res
        if opts.mode == "edit"
          promise = boardDA.putThread(opts.item._id, d).then ->
            modalOpts.data2item opts.item, d
      else if opts.type == "reply"
        if opts.mode == "create"
          promise = boardDA.postReply(opts.item._id, d).then (res) -> 
            opts.item.replies.splice 0, 0, res
        data.newMessage = ""
      promise?.then -> msgModal.hide()

  cancelMsgModal: ->
    console.log "board.coffee:217 >>>"
    _opts.board.threadModal.hide()
    _opts.board.replyModal.hide()
