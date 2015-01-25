app.controller "MessagesController", ($scope, $state, board, stateResolved, baseMessages, $ionicModal, user, userResolved, boardThreadHeight) ->

  console.log "Messages Controller"

  _addMsgModal = null
  
  $ionicModal.fromTemplateUrl("modals/addMsgSelector.html",
    scope : $scope
    animation: 'slide-in-up'
  ).then (res) ->
    _addMsgModal = res

  prms = 
    spot : stateResolved.spot.id, board : null, culture : stateResolved.culture.code

  _board = new board.Board prms, $scope, baseMessages.opts    

  $scope.board = _board
  $scope.spotTitle = stateResolved.spot.title
  $scope.filterMsgsForm = board.filterMsgsFormScope
  $scope.msgForm = baseMessages.opts.thread.scope.msgForm
  $scope.faqMsgForm = baseMessages.opts.thread.scope.faqMsgForm
  $scope.transferForm = baseMessages.opts.thread.scope.transferForm
  $scope.reportForm = baseMessages.opts.thread.scope.reportForm
  $scope.simpleMsgForm = baseMessages.opts.thread.scope.simpleMsgForm

  $scope.data = 
    containerElement : null

  if userResolved.settings?.msgsFilter
    _board.restoreFilter userResolved.settings.msgsFilter

  $scope.openThread = (thread) ->
    _board.setThread thread
    $state.transitionTo("root.main.messages-item.content", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : thread._id})

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
      _board.openThreadModal(thread, "create")
    _addMsgModal.hide()

  _board.loadMoreThreads()  

  $scope.getThreadHeight = (thread) ->
    boardThreadHeight.getHeight thread, $scope.data.containerElement

  $scope.$on '$destroy', ->
    console.log "messageController.coffee:55 >>>" 
    _board.dispose()

  $scope.openReplies = (thread) ->
    prms = threadId : thread._id, id : stateResolved.spot.id, culture : stateResolved.culture.code
    $state.go("root.main.messages-item.replies", prms)
