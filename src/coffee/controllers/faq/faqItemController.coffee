app.controller "FaqItemController", ($scope, board, thread, stateResolved, faq, $state) ->
  
  console.log "Faq Item Controller"

  $scope.board = board
  $scope.msgForm = faq.opts.thread.scope
  $scope.simpleMsgForm = faq.opts.reply.scope

  faq.opts.thread.moveToList = ->
    $state.transitionTo("root.msg.faq", {id : stateResolved.spot.id, culture : stateResolved.culture.code})

  board.init $scope, stateResolved.spot.id, "faq", thread, faq.opts
