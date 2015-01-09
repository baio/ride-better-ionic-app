app.controller "TransferItemController", ($scope, board, thread, stateResolved, transfer, $state) ->
  
  console.log "transfer Item Controller"

  $scope.board = board
  $scope.transferForm = transfer.opts.thread.scope
  $scope.simpleMsgForm = transfer.opts.reply.scope

  transfer.opts.thread.moveToList = ->
    $state.transitionTo("root.transfer.list", {id : stateResolved.spot.id, culture : stateResolved.culture.code})

  board.init $scope, stateResolved.spot.id, "transfer", thread, transfer.opts



