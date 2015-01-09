app.controller "ReportsItemController", ($scope, board, thread, stateResolved, report, $state) ->
  
  console.log "Reports Item Controller"

  $scope.board = board
  $scope.msgForm = report.opts.thread.scope
  $scope.simpleMsgForm = report.opts.reply.scope

  report.opts.thread.moveToList = ->
    $state.transitionTo("root.reports.list", {id : stateResolved.spot.id, culture : stateResolved.culture.code})

  board.init $scope, stateResolved.spot.id, "report", thread, report.opts