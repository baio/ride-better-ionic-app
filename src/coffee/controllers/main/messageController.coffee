app.controller "MessageController", ($scope, $state, board, thread, stateResolved, messages, faq, report, transfer, $ionicModal, boardThreadHeight) ->

  console.log "MessageItem Controller"

  $scope.board = board
  $scope.msgForm = messages.opts.thread.scope
  $scope.faqMsgForm = faq.opts.thread.scope
  $scope.transferForm = transfer.opts.thread.scope
  $scope.reportForm = report.opts.thread.scope
  $scope.simpleMsgForm = messages.opts.reply.scope
  $scope.data = containerElement : null


  messages.opts.thread.moveToList = ->
    $state.transitionTo("root.main.messages", {id : stateResolved.spot.id, culture : stateResolved.culture.code})

  isThreadOfType = (thd, type) ->
    thd.tags.indexOf(type) != -1

  $scope.isThreadOfType = isThreadOfType

  initBoard = ->
    boardOpts =  
      if isThreadOfType(thread, "faq")
        name : "faq"
        opts : faq.opts
      else if isThreadOfType(thread, "message")
        name : "message"
        opts : messages.opts
      else if isThreadOfType(thread, "transfer")
        name : "transfer"
        opts : transfer.opts
      else if isThreadOfType(thread, "report")
        name : "report"
        opts : report.opts

    board.init {spot : stateResolved.spot.id, board : null, culture : stateResolved.culture.code}, $scope, thread, boardOpts.opts

  initBoard()

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
    prms = threadId : thread._id, id : stateResolved.spot.id, culture : stateResolved.culture.code
    $state.go("root.main.messages-item.requests", prms)

  $scope.getReplyHeight = (reply) ->
    boardThreadHeight.getReplyHeight reply, $scope.data.containerElement
