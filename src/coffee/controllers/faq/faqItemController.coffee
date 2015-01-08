app.controller "FaqItemController", ($scope, board, thread, stateResolved, faq) ->
  
  console.log "Faq Item Controller"

  $scope.board = board
  $scope.msgForm = faq.opts.thread.scope
  $scope.simpleMsgForm = faq.opts.reply.scope

  board.init $scope, stateResolved.spot.id, "faq", thread, faq.opts
