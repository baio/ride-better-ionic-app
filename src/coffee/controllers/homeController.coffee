app.controller "HomeController", ($scope, snapshotDA, reportsDA, user, $state) ->

  console.log "Home Controller"

  setSnapshot = (data) ->
    if data
      $scope.snapshot = data

  home = user.getHome()

  if home
    snapshotDA.get(home.code).then setSnapshot

  $scope.$on "user.changed", ->
    snapshotDA.get(user.getHome().code).then setSnapshot

  $scope.sendReport = ->
    console.log ">>>homeController.coffee:18"
    user.login().then ->
      $state.go "tab.report"

  $scope.closedReport = ->
    user.login().then ->
      $state.go "tab.closed"
