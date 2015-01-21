__firstLoad = true

app.controller "MessagesController", ($scope, $state, board, stateResolved, baseMessages, $ionicModal, user, userResolved, boardThreadHeight, filterResolved) ->

  console.log "Messages Controller"

  _addMsgModal = null
  
  $ionicModal.fromTemplateUrl("modals/addMsgSelector.html",
    scope : $scope
    animation: 'slide-in-up'
  ).then (res) ->
    _addMsgModal = res

  console.log "messagesController.coffee:13 >>>", stateResolved.spot

  $scope.board = board
  $scope.spotTitle = stateResolved.spot.title
  $scope.filterMsgsForm = board.filterMsgsFormScope
  $scope.msgForm = baseMessages.opts.thread.scope.msgForm
  $scope.faqMsgForm = baseMessages.opts.thread.scope.faqMsgForm
  $scope.transferForm = baseMessages.opts.thread.scope.transferForm
  $scope.reportForm = baseMessages.opts.thread.scope.reportForm
  $scope.simpleMsgForm = baseMessages.opts.thread.scope.simpleMsgForm

  $scope.data = 
    containerElement : null

  console.log "messagesController.coffee:24 >>>", userResolved
  if userResolved.settings?.msgsFilter
    board.restoreFilter userResolved.settings.msgsFilter

  $scope.openThread = (threadId) ->
    $state.transitionTo("root.main.messages-item.content", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})

  $scope.openAddMsgSelector = ->
    user.login().then ->
      _addMsgModal.show()

  $scope.cancelAddMsgSelector = ->
    _addMsgModal.hide()

  $scope.$on '$destroy', ->
    _addMsgModal.remove()

  $scope.createThreadModal = (thread) ->
    if thread == "report"
      $state.transitionTo("root.main.report", {id : stateResolved.spot.id, culture : stateResolved.culture.code})
    else
      board.openThreadModal(thread, "create")
    _addMsgModal.hide()

  loadThreads = ->
    board.clean()
    board.loadMoreThreads()  

  getStaticFilter = ->
    if filterResolved.filter
      obj = 
        spot : stateResolved.spot.id
      for spt in filterResolved.filter.split(",")
        kv = spt.split("=")
        obj[kv[0]] = kv[1]
      obj

  $scope.$on "$ionicView.enter", ->
    console.log "messagesController.coffee:62 >>>", "$ionicView.enter", __firstLoad
    board.init {spot : stateResolved.spot.id, board : null, culture : stateResolved.culture.code, filter : getStaticFilter}, $scope, null, baseMessages.opts    
    if __firstLoad or filterResolved.filter
      loadThreads()
      __firstLoad = !!filterResolved.filter

  $scope.getThreadHeight = (thread) ->
    boardThreadHeight.getHeight thread, $scope.data.containerElement

  $scope.$on '$destroy', ->
    console.log "messageController.coffee:55 >>>" 
    board.dispose()

