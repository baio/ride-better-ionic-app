app.controller "MessagesController", ($scope, $state, board, stateResolved, baseMessages, $ionicModal, user) ->

  console.log "Messages Controller"

  _addMsgModal = null

  $ionicModal.fromTemplateUrl("modals/addMsgSelector.html",
    scope : $scope
    animation: 'slide-in-up'
  ).then (res) ->
    _addMsgModal = res

  $scope.board = board
  $scope.msgForm = baseMessages.opts.thread.scope.msgForm
  $scope.faqMsgForm = baseMessages.opts.thread.scope.faqMsgForm
  $scope.transferForm = baseMessages.opts.thread.scope.transferForm
  $scope.reportForm = baseMessages.opts.thread.scope.reportForm
  $scope.simpleMsgForm = baseMessages.opts.thread.scope.simpleMsgForm

  $scope.filter = "current"

  baseMessages.opts.thread.getLoadSpot = ->
    if $scope.filter == "current"
      stateResolved.spot.id
    else if $scope.filter == "favs"      
      user.user.settings.favs.map((m) -> m.id).join("-") 
    else if $scope.filter == "all"
      "-"

  $scope.$on "$ionicView.enter", ->
    console.log "messagesController.coffee:31 >>>", "$ionicView.enter"
    board.init $scope, stateResolved.spot.id, null, null, baseMessages.opts
    board.clean()
    board.loadMoreThreads()  

  $scope.isThreadOfType = baseMessages.opts.thread.scope.isThreadOfType

  $scope.openThread = (threadId) ->
    $state.transitionTo("root.main.messages-item", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})

  $scope.openAddMsgSelector = ->
    user.login().then ->
      _addMsgModal.show()

  $scope.cancelAddMsgSelector = ->
    _addMsgModal.hide()

  $scope.$on '$destroy', ->
    _addMsgModal.remove()

  $scope.createThreadModal = (thread) ->
    if thread == "report"
      $state.transitionTo("root.main.report", {id : stateResolved.spot.id, culture : stateResolved.culture.code})
    else
      board.openThreadModal(thread, "create")
    _addMsgModal.hide()

  $scope.setActiveFilter = (filter) ->
    if filter != $scope.filter
      $scope.filter = filter
      board.clean()
      board.loadMoreThreads()  

  $scope.isActiveFilter = (filter) ->
    $scope.filter == filter
