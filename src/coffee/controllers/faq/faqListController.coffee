app.controller "FaqListController", ($scope, $state, board, stateResolved, faq) ->

  console.log "Faq List Controller"

  $scope.board = board
  $scope.msgForm = faq.opts.thread.scope
  $scope.simpleMsgForm = faq.opts.reply.scope

  board.init $scope, stateResolved.spot.id, "faq", null, faq.opts

  board.loadMoreThreads()  

  $scope.openThread = (threadId) ->
    $state.transitionTo("root.msg.faq-item", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})


