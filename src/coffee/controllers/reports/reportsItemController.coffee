app.controller "ReportsItemController", ($scope, board, thread, stateResolved, report, $state) ->
  
  console.log "Reports Item Controller"

  $scope.board = board
  $scope.msgForm = report.opts.thread.scope
  $scope.simpleMsgForm = report.opts.reply.scope

  report.opts.thread.moveToList = ->
    $state.transitionTo("root.msg.reports", {id : stateResolved.spot.id, culture : stateResolved.culture.code})

  $scope.$on "$ionicView.enter", ->  
    console.log "reportsItemController.coffee:13 >>>", "$ionicView.enter"
    board.init $scope, stateResolved.spot.id, "report", thread, report.opts