app.controller "SendReportController", ($scope, reportsDA, user, $state) ->

  console.log "SendReport Controller"

  $scope.data =
    tracks : null
    snowing : null
    crowd : null

  $scope.sendReport = ->
    home = user.getHome().code
    data = conditions :
      tracks : parseInt $scope.data.tracks
      snowing : parseInt $scope.data.snowing
      crowd : parseInt $scope.data.crowd
    reportsDA.send(home, data).then (res) ->
      $state.go "tab.home"

  $scope.cancelReport = ->
    $state.go "tab.home"

