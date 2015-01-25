app.controller "ImportantController", ($scope, $state, board, stateResolved, messages, user, boardThreadHeight, homeResolved, $q) ->

  console.log "ImportantController"

  filter = ->
    console.log "importantController.coffee:7 >>>" 
    priority : "important"
    spot : stateResolved.spot.id
    board : "message"

  load = ->
    console.log "importantController.coffee:12 >>>"
    if !$scope.board.data.threads.length
      $q.when
        items : homeResolved.latestImportant
        index : 0
        canLoadMoreThreads : true

  prms = 
    spot : stateResolved.spot.id
    board : "message"
    culture : stateResolved.culture.code
    filter : filter
    load : load

  _board = new board.Board prms, $scope, messages.opts

  $scope.board = _board
  $scope.spotTitle = stateResolved.spot.title
  $scope.msgForm = messages.opts.thread.scope
  $scope.simpleMsgForm = messages.opts.reply.scope

  $scope.data = 
    containerElement : null

  _board.loadMoreThreads()  
  
  $scope.getThreadHeight = (thread) ->
    boardThreadHeight.getHeight thread, $scope.data.containerElement

  $scope.$on '$destroy', ->
    console.log "messageController.coffee:55 >>>" 
    _board.dispose()

  $scope.openThread = (thread) ->
    prms = id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : thread._id
    $state.transitionTo("root.main.home-message.content", prms)

  $scope.openReplies = (thread) ->
    prms = threadId : thread._id, id : stateResolved.spot.id, culture : stateResolved.culture.code
    $state.go("root.main.home-message.replies", prms)
