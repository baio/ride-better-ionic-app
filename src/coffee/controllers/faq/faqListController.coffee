app.controller "FaqListController", ($scope, $state, board, stateResolved, faq) ->

  console.log "Faq List Controller"

  $scope.board = board
  $scope.msgForm = faq.opts.thread.scope
  $scope.simpleMsgForm = faq.opts.reply.scope

  $scope.openThread = (threadId) ->
    $state.transitionTo("root.msg.faq-item", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})

  $scope.$on "$ionicView.enter", ->
    console.log "faqListController.coffee:13 >>>", $ionicView.enter
    board.init $scope, stateResolved.spot.id, "faq", null, faq.opts
    board.clean()
    board.loadMoreThreads()  