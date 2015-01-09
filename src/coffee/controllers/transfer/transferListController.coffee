app.controller "TransferListController", ($scope, $state, board, stateResolved, transfer) ->

  console.log "Transfer List Controller"

  $scope.board = board
  $scope.transferForm = transfer.opts.thread.scope
  $scope.simpleMsgForm = transfer.opts.reply.scope

  board.init $scope, stateResolved.spot.id, "transfer", null, transfer.opts

  board.loadMoreThreads()  

  $scope.openThread = (threadId) ->
    $state.transitionTo("root.msg.transfer-item", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})