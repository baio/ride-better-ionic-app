app.controller "HomeController", ($scope, snapshotDA, reportsDA, user, $state) ->

  console.log "Home Controller"

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

  setSnapshot = (data) ->
    if data
      $scope.snapshot = data

  home = user.getHome()

  if home
    snapshotDA.get(home.code, user.getLang()).then setSnapshot

  $scope.$on "user.changed", ->
    snapshotDA.get(user.getHome().code, user.getLang()).then setSnapshot

  $scope.sendReport = ->
    user.login().then ->
      console.log ">>>homeController.coffee:33"
      $state.go "tab.report"
