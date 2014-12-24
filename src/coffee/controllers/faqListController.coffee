app.controller "FaqListController", ($scope, board) ->

  console.log "Faq List Controller"

  $scope.board = board

  board.init $scope, "faq"

  board.loadMoreThreads()

  $scope.$on '$destroy', -> board.dispose()
