app.controller "FaqItemController", ($scope, board, thread, spotResolved) ->
  
  console.log "Faq Item Controller"

  $scope.board = board

  board.init spotResolved, $scope, "faq", thread

  $scope.$on '$destroy', -> board.dispose()
