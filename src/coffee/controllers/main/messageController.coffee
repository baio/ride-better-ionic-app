app.controller "MessageController", ($scope, $state, board, thread, stateResolved, baseMessages, $ionicModal, boardThreadHeight) ->

  console.log "MessageItem Controller"

  _board = new board.Board {spot : stateResolved.spot.id, culture : stateResolved.culture.code}, $scope, baseMessages.opts
  _board.setThread thread

  $scope.board = _board
  $scope.data = containerElement : null

  $scope.msgForm = baseMessages.opts.thread.scope.msgForm
  $scope.faqMsgForm = baseMessages.opts.thread.scope.faqMsgForm
  $scope.transferForm = baseMessages.opts.thread.scope.transferForm
  $scope.reportForm = baseMessages.opts.thread.scope.reportForm
  $scope.simpleMsgForm = baseMessages.opts.thread.scope.simpleMsgForm

  ###
  messages.opts.thread.moveToList = ->
    $state.transitionTo("root.main.messages", {id : stateResolved.spot.id, culture : stateResolved.culture.code})
  ###

  _requestsModal = null

  $ionicModal.fromTemplateUrl("modals/transferRequestsForm.html",
    scope : $scope
    animation: 'slide-in-up'
  ).then (res) ->
    _requestsModal = res

  $scope.closeTransferRequests = (thread) ->
    _requestsModal.hide()

  $scope.$on '$destroy', ->
    console.log "messageController.coffee:55 >>>" 
    _requestsModal.remove()

  $scope.openReplies = (thread) ->
    prms = threadId : thread._id, id : stateResolved.spot.id, culture : stateResolved.culture.code
    $state.go("root.main.messages-item.replies", prms)

  $scope.openTransferRequests = (thread) ->
    console.log "messageController.coffee:42 >>>", thread
    prms = threadId : thread._id, id : stateResolved.spot.id, culture : stateResolved.culture.code
    $state.go("root.main.messages-item.requests", prms)

  $scope.getReplyHeight = (reply) ->
    boardThreadHeight.getReplyHeight reply, $scope.data.containerElement
