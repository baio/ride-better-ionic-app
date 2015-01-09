app.factory "board", (boardDA, user, $ionicModal, notifier) ->

  _opts = {}
  _defOpts = 
    board :
      threadModal : null
      replyModal : null
      boardName : null
      spot : null      
    thread :
      modalTemplate : "modals/sendSimpleMsgForm.html"
      map2send: -> 
      item2scope: (item) ->
      validate: ->
      reset: ->  
      moveToList: ->  
    reply: 
      modalTemplate : "modals/sendSimpleMsgForm.html"
      map2send: -> 
      item2scope: (item) ->
      validate: ->
      reset: ->  

  data = 
    currentThread : null
    canLoadMoreThreads : false
    canLoadMoreReplies : false
    threads : []

  setBoard = (res, index) ->
    data.currentThread = null
    data.threads.splice index, 0, res...

  loadBoard = (opts, pushIndex) ->
    boardDA.get({spot : _opts.board.spot, board : _opts.board.boardName}, opts).then (res) -> 
      setBoard(res, pushIndex)

  setThread = (res, index) ->
    if res
      data.threads = [res]
      data.currentThread = res

  loadThread = (id, opts, pushIndex) ->
    home = user.getHome()
    boardDA.getThread(id, opts).then (res) ->
      setThread(res, pushIndex)

  # --- Send Message Form ---

  createThreadModal = (template, scope) ->
    $ionicModal.fromTemplateUrl(template,
      scope : scope
      animation: 'slide-in-up'
    )

  openMsgModal = (item, mode, type) ->
    user.login()
    .then ->
      if type == "thread" 
        if _opts.board.threadModalConstruct
          _opts.board.threadModalConstruct(_opts.thread.modalTemplate(item))
        else
          _opts.board.threadModal 
      else 
        _opts.board.replyModal
    .then (msgModal) ->
      msgModal.opts = 
        type : type
        mode: mode
        item: item
      if mode == "edit"
        _opts[type].item2scope item
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
      till = moment.utc(first.created, "X").unix()
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
    if threadId
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

  init: (scope, spt, boardName, currentThread, opts) ->  
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
    if _opts.thread.modalTemplate
      if typeof _opts.thread.modalTemplate == "string"
        createThreadModal(_opts.thread.modalTemplate, scope)
        .then (modal1) ->
          _opts.board.threadModal = modal1
      else
        if _opts.board.threadModal
          _opts.board.threadModal.remove()
        _opts.board.threadModalConstruct = (template) ->
          createThreadModal(template, scope).then (modal1) ->
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
        isMoveBack = data.currentThread
        data.threads.splice data.threads.indexOf(thread), 1
        data.currentThread = null
        if isMoveBack
          _opts.thread.moveToList?()

  removeReply : (thread, reply) ->    
    notifier.confirm("After delete, item couldn't be restored. Delete?")
    .then (res) ->
      if res
        home = user.getHome().code
        boardDA.removeReply(reply._id)
    .then (res) ->
      if res
        thread.replies.splice thread.replies.indexOf(reply), 1

  dispose: -> 
    _opts.board.threadModal.remove()
    _opts.board.replyModal.remove()
    _opts.board.threadModal = null
    _opts.board.replyModal = null

  openThreadModal: (item, mode, modalOpts) ->
    openMsgModal item, mode, "thread"

  openReplyModal: (item, mode) ->
    openMsgModal item, mode, "reply"

  sendMessage: ->
    msgModal = getShownModal()
    opts = msgModal.opts
    modalOpts = _opts[opts.type]
    err = modalOpts.validate(opts.item)
    if err
      notifier.message err
    else
      home = _opts.board.spot
      d = modalOpts.map2send(opts.item)
      promise = null
      if opts.type == "thread"
        if opts.mode == "create"
          promise = boardDA.postThread({spot : home, board : modalOpts.boardName(opts.item)}, d).then (res) -> 
            data.threads.splice 0, 0, res
            modalOpts.reset()
        else if opts.mode == "edit"
          promise = boardDA.putThread(opts.item._id, d).then (res) ->
            data.threads.splice data.threads.indexOf(opts.item), 1, res
            if data.currentThread
              data.currentThread.data = res.data
      else if opts.type == "reply"
        if opts.mode == "create"
          promise = boardDA.postReply(opts.item._id, d).then (res) -> 
            opts.item.replies.splice 0, 0, res
        else if opts.mode == "edit"
          promise = boardDA.putReply(opts.item._id, d).then (res) -> 
            opts.item.data = res.data
      modalOpts.reset?(opts.item)
      promise?.then -> msgModal.hide()

  cancelMsgModal: ->
    msgModal = getShownModal()
    opts = msgModal.opts
    modalOpts = _opts[opts.type]    
    modalOpts.reset?(opts.item)
    msgModal.hide()

