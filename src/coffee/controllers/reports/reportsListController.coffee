app.controller "ReportsListController", ($scope, $state, board, stateResolved, report) ->

  console.log "Reports List Controller"

  $scope.board = board
  $scope.msgForm = report.opts.thread.scope
  $scope.simpleMsgForm = report.opts.reply.scope

  board.init $scope, stateResolved.spot.id, "report", null, report.opts

  board.loadMoreThreads()  

  $scope.openThread = (threadId) ->
    $state.transitionTo("root.msg.reports-item", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})

