app.controller "ForecastController", ($scope, forecast, $ionicScrollDelegate,  $ionicPosition, user) ->

  console.log "Forecast Controller"

  setForecast = (serviceData, scroll) ->
    if serviceData
      $scope.forecast = serviceData
      if scroll
        idx = $scope.forecast.items.indexOf $scope.forecast.items.filter((f) -> f.isCurrent)[0]
        $ionicScrollDelegate.$getByHandle("forecast-scroll").scrollTo 0, 112 * idx, false

  $scope.$on "$destroy", ->
    delegate = $ionicScrollDelegate.$getByHandle("forecast-scroll")
    delegate.forgetScrollPosition()


  homeCode =  user.getHome().code
  forecast.get(homeCode).then (res) -> setForecast res, true



