app.controller "ForecastController", ($scope, stateResolved) ->

  console.log "Forecast Controller"

  $scope.forecast = stateResolved.forecast




