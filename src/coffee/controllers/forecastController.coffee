app.controller "ForecastController", ($scope, forecast, $ionicScrollDelegate,  $ionicPosition, user) ->

  console.log "Forecast Controller"

  setForecast = (serviceData, scroll) ->
    if serviceData
      $scope.forecast = serviceData
      if scroll
        idx = $scope.forecast.conditions.indexOf $scope.forecast.conditions.filter((f) -> f.isCurrent)[0]
        $ionicScrollDelegate.$getByHandle("forecast-scroll").scrollTo 0, 112 * idx, false

  $scope.$on "$destroy", ->
    delegate = $ionicScrollDelegate.$getByHandle("forecast-scroll")
    delegate.forgetScrollPosition()


  homeCode =  user.getHome().code
  setForecast forecast.getForecastCache homeCode
  forecast.getForecast(homeCode).then (res) -> setForecast res, true



