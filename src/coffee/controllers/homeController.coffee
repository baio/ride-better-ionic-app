app.controller "HomeController", ($scope, snapshotDA, reportsDA, user) ->

  console.log "Home Controller"

  setSnapshot = (data) ->
    if data
      $scope.snapshot = data

  home = user.getHome()

  if home
    snapshotDA.get(home.code).then setSnapshot

  $scope.$on "user.changed", ->
    snapshotDA.get(user.getHome().code).then setSnapshot




