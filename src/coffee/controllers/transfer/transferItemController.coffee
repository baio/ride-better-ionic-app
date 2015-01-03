app.controller "TransferItemController", ($scope, board, thread, stateResolved) ->
  
  console.log "transfer Item Controller"

  $scope.board = board

  board.init stateResolved.spot.id, $scope, "transfer", thread

  $scope.$on '$destroy', -> board.dispose()
