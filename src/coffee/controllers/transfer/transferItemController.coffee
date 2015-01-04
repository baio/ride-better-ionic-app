app.controller "TransferItemController", ($scope, board, thread, stateResolved, transfer) ->
  
  console.log "transfer Item Controller"

  $scope.board = board

  $scope.data = transfer.scope.data
  $scope.transportTypesList = transfer.scope.transportTypesList
  $scope.hoursList = transfer.scope.hoursList


  board.init stateResolved.spot.id, $scope, "transfer", thread, transfer.opts


  #$scope.$on '$destroy', -> board.dispose()
