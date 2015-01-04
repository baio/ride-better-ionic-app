app.controller "TransferListController", ($scope, $state, board, stateResolved, transfer) ->

  console.log "Transfer List Controller"

  $scope.board = board

  $scope.data = transfer.scope.data
  $scope.transportTypesList = transfer.scope.transportTypesList
  $scope.hoursList = transfer.scope.hoursList

  board.init stateResolved.spot.id, $scope, "transfer", null, transfer.opts

  board.loadMoreThreads()

  $scope.openThread = (threadId) ->
    $state.transitionTo("root.transfer.item", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})