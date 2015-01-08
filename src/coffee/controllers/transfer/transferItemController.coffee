app.controller "TransferItemController", ($scope, board, thread, stateResolved, transfer) ->
  
  console.log "transfer Item Controller"

  $scope.board = board
  $scope.transferForm = transfer.opts.thread.scope
  $scope.simpleMsgForm = transfer.opts.reply.scope

  board.init $scope, stateResolved.spot.id, "transfer", thread, transfer.opts



