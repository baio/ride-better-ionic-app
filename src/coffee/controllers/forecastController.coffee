app.controller "ForecastController", ($scope, homeDA, user, spotResolved) ->

  console.log "Forecast Controller"

  setForecast = (data) ->
    if data
      $scope.forecast = data.forecast

  homeDA.get(spot : spotResolved, lang : user.getLang(), culture : user.getCulture()).then (res) -> setForecast res



