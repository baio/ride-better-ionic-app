app.controller "MessagesItemController", ($scope, board, thread, stateResolved, messages) ->
  
  console.log "Messages Item Controller"

  $scope.board = board
  $scope.msgForm = messages.opts.thread.scope
  $scope.simpleMsgForm = messages.opts.reply.scope

  board.init $scope, stateResolved.spot.id, "message", thread, messages.opts