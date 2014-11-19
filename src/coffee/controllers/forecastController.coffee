app.controller "ForecastController", ($scope, homeDA, user) ->

  console.log "Forecast Controller"

  setForecast = (data) ->
    if data
      $scope.forecast = data.forecast

  homeCode =  user.getHome().code
  homeDA.get(homeCode, user.getLang()).then (res) -> setForecast res



