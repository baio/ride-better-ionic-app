app.controller "ReportsController", ($scope, stateResolved) ->

  console.log "Reports Controller"

  $scope.reports = stateResolved.reports


