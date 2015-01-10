app.controller "MessagesController", ($scope, $state, board, stateResolved, baseMessages, $ionicModal) ->

  console.log "Messages Controller"

  _addMsgModal = null

  $ionicModal.fromTemplateUrl("modals/addMsgSelector.html",
    scope : $scope
    animation: 'slide-in-up'
  ).then (res) ->
    _addMsgModal = res

  $scope.board = board
  $scope.msgForm = baseMessages.opts.thread.scope.msgForm
  $scope.faqMsgForm = baseMessages.opts.thread.scope.faqMsgForm
  $scope.transferForm = baseMessages.opts.thread.scope.transferForm
  $scope.reportForm = baseMessages.opts.thread.scope.reportForm
  $scope.simpleMsgForm = baseMessages.opts.thread.scope.simpleMsgForm

  board.init $scope, stateResolved.spot.id, null, null, baseMessages.opts

  board.loadMoreThreads()  

  $scope.isThreadOfType = baseMessages.opts.thread.scope.isThreadOfType

  $scope.openThread = (threadId) ->
    $state.transitionTo("root.main.messages-item", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})

  $scope.openAddMsgSelector = ->
    console.log "messagesController.coffee:30 >>>"
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

