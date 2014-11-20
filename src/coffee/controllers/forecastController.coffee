app.controller "ForecastController", ($scope, homeDA, user) ->

  console.log "Forecast Controller"

  setForecast = (data) ->
    if data
      $scope.forecast = data.forecast

  home =  user.getHome()
  homeDA.get(spot : home.code, lang : user.getLang(), culture : user.getCulture()).then (res) -> setForecast res



