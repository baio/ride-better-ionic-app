app.controller "SendReportController", ($scope, reportsDA, user, $state) ->

  console.log "SendReport Controller"

  $scope.data =
    tracks : null
    snowing : null
    crowd : null

  $scope.sendReport = ->
    home = user.getHome().code
    reportsDA.send(home, $scope.data).then (res) ->
      $state.go "tab.home"

  $scope.cancelReport = ->
    $state.go "tab.home"

