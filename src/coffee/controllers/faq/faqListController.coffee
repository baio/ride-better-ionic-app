app.controller "FaqListController", ($scope, $state, board, stateResolved) ->

  console.log "Faq List Controller"

  $scope.board = board

  board.init stateResolved.spot.id, $scope, "faq"

  board.loadMoreThreads()

  $scope.$on '$destroy', -> board.dispose()

  $scope.openThread = (threadId) ->
    console.log "faqListController.coffee:18 >>>", stateResolved, threadId
    $state.transitionTo("faq.item", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})
