app.service "board", ($rootScope, boardDA, user, $ionicModal, notifier, filterMsgsFormScope, $q, $ionicScrollDelegate) ->
  
  _defOpts = 
    board :
      threadModal : null
      replyModal : null
      boardName : null
      spot : null     
      culture : null 
      filter : null
    thread :
      modalTemplate : "modals/sendSimpleMsgForm.html"
      map2send: -> 
      item2scope: (item) ->
      validate: ->
      reset: ->  
      moveToList: ->  
      getLoadSpot: null        
      getCreateBoardName: null
    reply: 
      modalTemplate : "modals/sendSimpleMsgForm.html"
      map2send: -> 
      item2scope: (item) ->
      validate: ->
      reset: ->  

  createThreadModal = (template, scope) ->
    $ionicModal.fromTemplateUrl(template,
      scope : scope
      animation: 'slide-in-up'
    )


  class Board     

    constructor: (prms, scope, opts) ->

      @_opts = {}
      @data =       
        currentThread : null
        canLoadMoreThreads : false
        canLoadMoreReplies : false
        threads : []        

      @init prms, scope, opts    

    getFilter: (spot) ->   
      _opts =  @_opts
      if _opts.board.filter      
        filter = _opts.board.filter()
        if filter then return $q.when filter

      d = filterMsgsFormScope.scope.data
      filterSpotsPromise = switch d.spots 
        when "current"
          $q.when spot
        when "favs"      
          user.getUserAsync().then (ur) ->
            ur.settings.favs.map((m) -> m.id).join("-") 
        when "all"
          $q.when "-"              
      boards = []
      if d.messages
        boards.push "message"
      if d.faq
        boards.push "faq"
      if d.reports
        boards.push "report"
      if d.transfers
        boards.push "transfer"
      filterBoards = if boards.length == 4 then undefined else boards.join "-"

      filterSpotsPromise.then (filterSpots) ->      
        spot : filterSpots
        board : filterBoards        

    openMsgModal: (item, mode, type, parent) ->
      _opts = @_opts    
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
          parent: parent
          boardName: _opts.board.boardName
        if mode == "edit"
          _opts[type].item2scope item
        else if mode == "create"
          if type == "thread" and _opts.thread.getCreateBoardName
            msgModal.opts.boardName = _opts.thread.getCreateBoardName(item)
        msgModal.show()

    resetData : ->
      @data.currentThread = null
      @data.canLoadMoreThreads = false
      @data.canLoadMoreReplies = false      

    getShownModal : ->
      _opts = @_opts
      if _opts.board.threadModal?.isShown() then _opts.board.threadModal else _opts.board.replyModal      

    init: (prms, scope, opts) ->   

      $rootScope.$on "thread::remove", (evt, thread) =>
        console.log "board.coffee:113 >>>", thread
        for th, i in @data.threads
          if th._id == thread._id
            console.log "board.coffee:116 >>>", i 
            @data.threads.splice i, 1
            break

      angular.copy _defOpts, @_opts
      _opts = @_opts
      @dispose()
      if opts?.thread
        _opts.thread = opts.thread
      if opts?.reply
        _opts.reply = opts.reply      
      _opts.board.spot = prms.spot
      _opts.board.boardName = prms.board
      _opts.board.culture = prms.culture
      _opts.board.filter = prms.filter
      _opts.board.load = prms.load
      @resetData()
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
      $ionicModal.fromTemplateUrl("modals/filterMsgsForm.html",
            scope : scope
            animation: 'slide-in-up'
          ).then (modal3) =>
            @_filterModal = modal3

    setBoard : (res, index) ->
      @data.currentThread = null
      index = @data.threads.length if index == -1
      @data.threads.splice index, 0, res...
      @data.canLoadMoreThreads = res.length >= 50

    loadBoardExternal : ->
      _opts = @_opts
      loader = _opts.board.load?()
      if loader
        _opts.board.load().then (res) =>
          @setBoard(res.items, res.index)
          @data.canLoadMoreThreads = res.canLoadMore
      loader

    loadBoard : (opts, pushIndex) ->

      _opts = @_opts
      #!!!spot = if _opts.thread.getLoadSpot then _opts.thread.getLoadSpot() else _opts.board.spot
      extarnalLoader = @loadBoardExternal()
      if extarnalLoader
        return extarnalLoader

      spot = _opts.board.spot
      board = _opts.board.boardName

      @getFilter(spot)
      .then (filter) =>     
        opts ?= {}
        opts.culture = @_opts.board.culture    
        opts.priority = filter.priority
        delete filter.priority
        boardDA.get(filter, opts)
      .then (res) => 
        @setBoard(res, pushIndex)
      .catch =>
        @data.canLoadMoreThreads = false

    setThread : (res, index) ->
      if res
        @data.currentThread = res
      @data.canLoadMoreReplies = false

    loadThread : (id, opts, pushIndex) ->
      opts ?= {}
      opts.culture = @_opts.board.culture
      boardDA.getThread(id, opts).then (res) =>
        @setThread(res, pushIndex)
      .catch =>
        @data.canLoadMoreReplies = true

    loadMoreThreads : ->    
      last = @data.threads[@data.threads.length - 1]
      if last
        since = moment.utc(last.created, "X").unix()
      @loadBoard(since : since, -1)
      .finally ->
        $rootScope.$broadcast "scroll.infiniteScrollComplete"

    pullMoreThreads : ->
      first = @data.threads[0]
      if first
        till = moment.utc(first.created, "X").unix()
      @loadBoard(till : till, 0).finally ->
        $rootScope.$broadcast "scroll.refreshComplete"
        
    getThread : (threadId) ->
      @data.threads.filter((f) -> f._id == threadId)[0]

    loadMoreReplies : (thread) ->    
      last = thread.replies[thread.replies.length - 1]
      if last
        since = moment.utc(last.created, "X").unix()
      @loadThread(thread._id, since : since).then (res) =>
        @data.canLoadMoreReplies = res.length >= 25
        $rootScope.$broadcast "scroll.infiniteScrollComplete"
      .catch =>
        @data.canLoadMoreReplies = false

    pullMoreReplies : (thread) ->
      first = thread.replies[0]
      if first
        till = moment.utc(first.created, "X").unix()
      @loadThread(thread._id, till : till, 0).finally ->
        $rootScope.$broadcast "scroll.refreshComplete"

    clean: ->
      @resetData()
      @data.threads = []

    removeThread : (thread) ->    
      notifier.confirm("confirm_delete")
      .then (res) ->
        if res
          home = user.getHome().code
          boardDA.removeThread(thread)
      .then (res) =>        
        @data.currentThread = null
        $rootScope.$broadcast "thread::remove", thread
          
    removeReply : (thread, reply) ->    
      notifier.confirm("confirm_delete")
      .then (res) ->
        if res
          home = user.getHome().code
          boardDA.removeReply(reply, thread)

    dispose: -> 
      _opts = @_opts
      if _opts.board.threadModal
        _opts.board.threadModal.remove()
        _opts.board.replyModal.remove()
        
        _opts.board.threadModal = null
        _opts.board.replyModal = null
      if @_filterModal 
        @_filterModal.remove()
        @_filterModal = null

    openThreadModal: (item, mode, modalOpts) ->
      @openMsgModal item, mode, "thread"

    openReplyModal: (item, mode, parent) ->
      @openMsgModal item, mode, "reply", parent

    sendMessage: ->
      _opts = @_opts
      msgModal = @getShownModal()
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
            promise = boardDA.postThread({spot : home, board : opts.boardName}, d).then (res) => 
              @data.threads.splice 0, 0, res            
          else if opts.mode == "edit"
            promise = boardDA.putThread(opts.item._id, d).then (res) =>
              @data.threads.splice @data.threads.indexOf(opts.item), 1, res
              if @data.currentThread
                @data.currentThread.data = res.data
        else if opts.type == "reply"
          if opts.mode == "create"
            promise = boardDA.postReply(opts.item, d)
          else if opts.mode == "edit"
            promise = boardDA.putReply(opts.item, opts.parent, d)
        modalOpts.reset?(opts.item)
        promise?.then -> msgModal.hide()

    cancelMsgModal: ->
      msgModal = @getShownModal()
      opts = msgModal.opts
      modalOpts = @_opts[opts.type]    
      modalOpts.reset?(opts.item)
      msgModal.hide()

    openFilterModal: ->
      @_filterModal.show()

    cancelFilterModal: ->
      @_filterModal.hide()

    filter: ->    
      @clean()
      @_filterModal.hide()
      .then =>
        @loadBoard()
      .then ->
        user.setMsgsFilter filterMsgsFormScope.serialize()
        $ionicScrollDelegate.scrollTop false

    restoreFilter: (data) ->
      filterMsgsFormScope.deserialize(data)

    requestTransfer : (thread) ->
      user.login().then ->
        boardDA.requestTransfer thread

    unrequestTransfer : (thread) ->
      notifier.confirm("unrequest_transfer")
      .then (f) ->
        if !f 
          $q.reject()
        else
          user.login()
      .then ->
        boardDA.unrequestTransfer thread    

    userRequestStatus : (thread) ->
      if thread.requests
        userRequest = thread.requests.filter((f) -> f.user.key == user.getKey())[0]
        if userRequest
          if userRequest.accepted == true
            return "accepted"
          else if userRequest.accepted == false
            return "rejected"
          else
            return "requested"      
      return "none"

    switchAccepted : (thread, request) ->
      f = !request.accepted
      boardDA.acceptTransferRequest(thread, request, f)


  Board : Board        
  filterMsgsFormScope : filterMsgsFormScope.scope