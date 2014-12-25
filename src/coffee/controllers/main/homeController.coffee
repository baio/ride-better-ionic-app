app.controller "HomeController", ($scope, homeResolved) ->

  console.log "homeController.coffee:3 >>>", homeResolved

  $scope.getBackgroundStyle = (icon) ->
    if !icon
      return null
    if icon.indexOf("clear") != -1
      return "home-container-sun"
    else if icon.indexOf("partly-cloudy") != -1
      return "home-container-light-clouds"
    else if icon == "cloudy"
      return "home-container-clouds"
    else if icon == "snow"
      return "home-container-snow"
    else
      return "home-container-light-clouds"

  $scope.snapshot = homeResolved.snapshot
  $scope.snowfallHistory = homeResolved.snowfallHistory



