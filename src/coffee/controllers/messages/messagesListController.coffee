app.controller "MessagesListController", ($scope, $state, board, stateResolved, messages) ->

  console.log "Messages List Controller"

  $scope.board = board
  $scope.msgForm = messages.opts.thread.scope
  $scope.simpleMsgForm = messages.opts.reply.scope

  messages.opts.thread.moveToList = ->
    $state.transitionTo("root.messages.list", {id : stateResolved.spot.id, culture : stateResolved.culture.code})

  board.init $scope, stateResolved.spot.id, "message", null, messages.opts

  board.loadMoreThreads()  

  $scope.openThread = (threadId) ->
    $state.transitionTo("root.messages.item", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})

