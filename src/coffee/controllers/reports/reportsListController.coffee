app.controller "ReportsListController", ($scope, $state, board, stateResolved, report) ->

  console.log "Reports List Controller"

  $scope.board = board
  $scope.msgForm = report.opts.thread.scope
  $scope.simpleMsgForm = report.opts.reply.scope

  $scope.openThread = (threadId) ->
    $state.transitionTo("root.msg.reports-item", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})

  $scope.$on "$ionicView.enter", ->
    console.log "reportsListController.coffee:17 >>>", "$ionicView.enter"
    board.init {spot : stateResolved.spot.id, board : "report", culture : stateResolved.culture.code}, $scope, null, report.opts
    board.clean()
    board.loadMoreThreads()  