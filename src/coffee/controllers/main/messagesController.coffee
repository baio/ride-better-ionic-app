app.controller "MessagesController", ($scope, $state, board, stateResolved, baseMessages) ->

  console.log "Messages Controller"

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

