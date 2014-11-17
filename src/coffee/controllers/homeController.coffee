app.controller "HomeController", ($scope, snapshotDA, reportsDA, user, $state) ->

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

  loadSnapshot = ->
    home = user.getHome()
    snapshotDA.get(home.code, user.getLang()).then setSnapshot

  if $scope.$root.activated
    loadSnapshot()

  $scope.$on "app.activated", loadSnapshot

  $scope.sendReport = ->
    user.login().then ->
      $state.go "tab.report"
