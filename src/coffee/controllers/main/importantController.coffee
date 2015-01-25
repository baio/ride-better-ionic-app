app.controller "ImportantController", ($scope, $state, board, stateResolved, messages, user, boardThreadHeight, homeResolved, $q) ->

  console.log "ImportantController"

  filter = ->
    console.log "importantController.coffee:7 >>>" 
    priority : "important"
    spot : stateResolved.spot.id
    board : "message"

  load = ->
    console.log "importantController.coffee:12 >>>"
    if !board.data.threads.length
      $q.when
        items : homeResolved.latestImportant
        index : 0
        canLoadMoreThreads : true

  $scope.board = board
  $scope.spotTitle = stateResolved.spot.title
  $scope.msgForm = messages.opts.thread.scope.msgForm
  $scope.simpleMsgForm = messages.opts.thread.scope.simpleMsgForm

  $scope.data = 
    containerElement : null

  $scope.openThread = (threadId) ->
    $state.transitionTo("root.main.messages-item.content", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})

  loadThreads = ->
    board.clean()
    board.loadMoreThreads()  
  
  $scope.$on "$ionicView.enter", ->
    board.init {spot : stateResolved.spot.id, board : "message", culture : stateResolved.culture.code, filter : filter, load : load}, $scope, null, messages.opts
    loadThreads()

  $scope.getThreadHeight = (thread) ->
    boardThreadHeight.getHeight thread, $scope.data.containerElement

  $scope.$on '$destroy', ->
    console.log "messageController.coffee:55 >>>" 
    board.dispose()

  $scope.openReplies = (thread) ->
    prms = threadId : thread._id, id : stateResolved.spot.id, culture : stateResolved.culture.code
    $state.go("root.main.messages-item.replies", prms)
