app.controller "FaqListController", ($scope, board, spotResolved) ->

  console.log "Faq List Controller"

  $scope.board = board

  board.init spotResolved, $scope, "faq"

  board.loadMoreThreads()

  $scope.$on '$destroy', -> board.dispose()
