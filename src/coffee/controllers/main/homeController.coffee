app.controller "HomeController", ($scope, homeResolved, stateResolved, $state) ->

  console.log "homeController.coffee:3 >>>"
   
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

  $scope.openImportant = ->
    $state.transitionTo("root.main.home-important", {id : stateResolved.spot.id, culture : stateResolved.culture.code})

  $scope.openReports = ->
    $state.transitionTo("root.main.home-reports", {id : stateResolved.spot.id, culture : stateResolved.culture.code})