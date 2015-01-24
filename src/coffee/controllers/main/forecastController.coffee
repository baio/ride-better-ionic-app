app.controller "ForecastController", ($scope, homeResolved, stateResolved, $state) ->

  console.log "Forecast Controller"

  $scope.forecast = homeResolved.forecast

  $scope.openHourly = (index) ->
    $state.transitionTo("root.main.forecast-hourly", {id : stateResolved.spot.id, culture : stateResolved.culture.code, index : index})

