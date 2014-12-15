app.controller "ForecastController", ($scope, homeDA, user) ->

  console.log "Forecast Controller"

  setForecast = (data) ->
    if data
      $scope.forecast = data.forecast

  homeDA.get(spot : user.getHome().code, lang : user.getLang(), culture : user.getCulture()).then (res) -> setForecast res



