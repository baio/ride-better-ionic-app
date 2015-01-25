app.controller "ForecastController", ($scope, homeResolved, stateResolved, $state) ->

  console.log "Forecast Controller"

  $scope.forecast = homeResolved.forecast

  $scope.openHourly = (item) ->
    if item.hourly
      index = $scope.forecast.indexOf item
      $state.transitionTo("root.main.forecast-hourly", {id : stateResolved.spot.id, culture : stateResolved.culture.code, index : index})

