app.controller "HomeController", ($scope, snapshotDA, reportsDA, user, $state) ->

  console.log "Home Controller"

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
      $state.go "tab.report"

  $scope.closedReport = ->
    user.login().then ->
      $state.go "tab.closed"
