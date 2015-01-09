app.controller "MessagesController", ($scope, $state, board, stateResolved, messages) ->

  console.log "Messages Controller"

  $scope.board = board
  $scope.msgForm = messages.opts.thread.scope
  $scope.simpleMsgForm = messages.opts.reply.scope

  board.init $scope, stateResolved.spot.id, null, null, messages.opts

  board.loadMoreThreads()  

  $scope.openThread = (threadId) ->
    #$state.transitionTo("root.msg.messages-item", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})

