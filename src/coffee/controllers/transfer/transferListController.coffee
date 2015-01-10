app.controller "TransferListController", ($scope, $state, board, stateResolved, transfer) ->

  console.log "Transfer List Controller"

  $scope.board = board
  $scope.transferForm = transfer.opts.thread.scope
  $scope.simpleMsgForm = transfer.opts.reply.scope

  $scope.openThread = (threadId) ->
    $state.transitionTo("root.msg.transfer-item", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})

  $scope.$on "$ionicView.enter", ->
    console.log "transferListController.coffee:16 >>>", "$ionicView.enter"
    board.init $scope, stateResolved.spot.id, "transfer", null, transfer.opts
    board.clean()
    board.loadMoreThreads()      