app.controller "ForecastController", ($scope, homeResolved) ->

  console.log "Forecast Controller"

  $scope.forecast = homeResolved.forecast




