app.controller "FaqItemController", ($scope, board, thread) ->
  
  console.log "Faq Item Controller"

  $scope.board = board

  board.init $scope, "faq", thread

  $scope.$on '$destroy', -> board.dispose()
