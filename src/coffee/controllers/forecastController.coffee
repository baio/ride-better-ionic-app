app.controller "ForecastController", ($scope, homeDA, home) ->

  console.log "Forecast Controller"

  setForecast = (data) ->
    if data
      $scope.forecast = data.forecast
      
  homeDA.get(spot : home.code, lang : user.getLang(), culture : user.getCulture()).then (res) -> setForecast res



