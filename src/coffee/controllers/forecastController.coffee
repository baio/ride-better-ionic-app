app.controller "ForecastController", ($scope, forecastDA, user) ->

  console.log "Forecast Controller"

  setForecast = (data) ->
    if data
      $scope.forecast = data

  homeCode =  user.getHome().code
  forecastDA.get(homeCode).then (res) -> setForecast res



