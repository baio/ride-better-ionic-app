app.controller "MessagesListController", ($scope, $state, board, stateResolved, messages, sendMsgFormScope) ->

  console.log "Messages List Controller"

  $scope.board = board
  $scope.formData = sendMsgFormScope.scope

  board.init stateResolved.spot.id, $scope, "message", null, messages.opts

  board.loadMoreThreads()  

  $scope.openThread = (threadId) ->
    $state.transitionTo("root.messages.item", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})

