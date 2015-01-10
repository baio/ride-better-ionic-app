app.controller "MessagesItemController", ($scope, board, thread, stateResolved, messages, $state) ->
  
  console.log "MessagesItem Controller"

  $scope.board = board
  $scope.msgForm = messages.opts.thread.scope
  $scope.simpleMsgForm = messages.opts.reply.scope

  messages.opts.thread.moveToList = ->
    $state.transitionTo("root.msg.messages", {id : stateResolved.spot.id, culture : stateResolved.culture.code})

  $scope.$on "$ionicView.enter", ->  
    console.log "messagesItemController.coffee:13 >>>", "$ionicView.enter"
    board.init {spot : stateResolved.spot.id, board : "message", culture : stateResolved.culture.code}, $scope, thread, messages.opts