app.controller "ReportController", ($scope, reports, user, $state) ->

  console.log "Report Controller"

  $scope.data =
    tracks : null
    snowing : null
    crowd : null

  $scope.sendReport = ->
    console.log ">>>reportController.coffee:6", $scope.data
    home = user.getHome().code
    reports.send(home, $scope.data).then (res) ->
      $state.go "tab.home"

  $scope.cancelReport = ->
    $state.go "tab.home"

