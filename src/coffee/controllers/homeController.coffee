app.controller "HomeController", ($scope, homeDA, reportsDA, user, $state) ->

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

  setSnapshot = (data) ->
    if data
      $scope.snapshot = data.snapshot
      $scope.snowfallHistory = data.snowfallHistory

  loadSnapshot = ->
    home = user.getHome()
    homeDA.get(spot : home.code, lang : user.getLang(), culture : user.getCulture()).then setSnapshot

  loadSnapshot()

  $scope.sendReport = ->
    user.login().then ->
      $state.go "tab.report"

  $scope.openInfo = ->
    $state.go "tab.info"

