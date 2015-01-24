app.controller "ForecastHourlyController", ($scope, homeResolved, indexResolved) ->

  console.log "ForecastHourly Controller"

  $scope.forecast = homeResolved.forecast[indexResolved].hourly




