app.controller "MessagesListController", ($scope, $state, board, stateResolved, messages) ->

  console.log "Messages List Controller"

  $scope.board = board
  $scope.msgForm = messages.opts.thread.scope
  $scope.simpleMsgForm = messages.opts.reply.scope

  $scope.openThread = (threadId) ->
    $state.transitionTo("root.msg.messages-item", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})

  $scope.$on "$ionicView.enter", ->
    console.log "messagesListController.coffee:17 >>>", "$ionicView.enter"
    board.init {spot : stateResolved.spot.id, board : "message", culture : stateResolved.culture.code}, $scope, null, messages.opts
    board.clean()
    board.loadMoreThreads()  