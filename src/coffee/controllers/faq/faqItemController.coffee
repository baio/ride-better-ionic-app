app.controller "FaqItemController", ($scope, board, thread, stateResolved, faq, $state) ->
  
  console.log "Faq Item Controller"

  $scope.board = board
  $scope.msgForm = faq.opts.thread.scope
  $scope.simpleMsgForm = faq.opts.reply.scope

  faq.opts.thread.moveToList = ->
    $state.transitionTo("root.msg.faq", {id : stateResolved.spot.id, culture : stateResolved.culture.code})

  $scope.$on "$ionicView.enter", ->  
    console.log "faqItemController.coffee:13 >>>", "$ionicView.enter"
    board.init $scope, stateResolved.spot.id, "faq", thread, faq.opts