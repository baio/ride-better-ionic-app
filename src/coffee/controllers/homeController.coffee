app.controller "HomeController", ($scope, homeDA, reportsDA, user, $state) ->

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
    console.log ">>>homeController.coffee:24", home
    homeDA.get(spot : home.code, lang : user.getLang(), culture : user.getCulture()).then setSnapshot

  if $scope.$root.activated
    loadSnapshot()

  $scope.$on "app.activated", loadSnapshot

  $scope.sendReport = ->
    user.login().then ->
      $state.go "tab.report"

  $scope.openInfo = ->
    $state.go "tab.info"

app.directive 'noScroll', ($document) ->
  restrict: 'A'
  link: ($scope, $element, $attr) ->
    $document.on 'touchmove', (e) ->
      e.preventDefault()
