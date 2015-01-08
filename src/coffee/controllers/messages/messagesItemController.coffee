app.controller "MessagesItemController", ($scope, board, thread, stateResolved) ->
  
  console.log "Messages Item Controller"

  $scope.board = board

  board.init stateResolved.spot.id, $scope, "message", thread

  $scope.$on '$destroy', -> board.dispose()
