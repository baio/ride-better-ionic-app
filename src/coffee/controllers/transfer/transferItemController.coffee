app.controller "TransferItemController", ($scope, board, thread, stateResolved, transfer, $state) ->
  
  console.log "transfer Item Controller"

  $scope.board = board
  $scope.transferForm = transfer.opts.thread.scope
  $scope.simpleMsgForm = transfer.opts.reply.scope

  transfer.opts.thread.moveToList = ->
    $state.transitionTo("root.msg.transfer", {id : stateResolved.spot.id, culture : stateResolved.culture.code})

  $scope.$on "$ionicView.enter", ->  
    console.log "transferItemController.coffee:13 >>>", "$ionicView.enter"
    board.init {spot : stateResolved.spot.id, board : "transfer", culture : stateResolved.culture.code}, $scope, thread, transfer.opts
