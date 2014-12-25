app.controller "ReportsController", ($scope, homeResolved) ->

  console.log "Reports Controller"

  $scope.reports = homeResolved.reports


