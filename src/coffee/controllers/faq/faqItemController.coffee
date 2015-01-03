app.controller "FaqItemController", ($scope, board, thread, stateResolved) ->
  
  console.log "Faq Item Controller"

  $scope.board = board

  board.init stateResolved.spot.id, $scope, "faq", thread

  #$scope.$on '$destroy', -> board.dispose()
