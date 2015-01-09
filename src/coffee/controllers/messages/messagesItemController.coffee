app.controller "MessagesItemController", ($scope, board, thread, stateResolved, messages, $state) ->
  
  console.log "Messages Item Controller"

  $scope.board = board
  $scope.msgForm = messages.opts.thread.scope
  $scope.simpleMsgForm = messages.opts.reply.scope

  messages.opts.thread.moveToList = ->
    $state.transitionTo("root.messages.list", {id : stateResolved.spot.id, culture : stateResolved.culture.code})

  board.init $scope, stateResolved.spot.id, "message", thread, messages.opts