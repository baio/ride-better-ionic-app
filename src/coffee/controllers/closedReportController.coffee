app.controller "ClosedReportController", ($scope, reportsDA, user, $state) ->

  console.log "ClosedReportController"

  $scope.reasonsList = [
    {code : "closed", name : "Unknown"}
    {code : "day-off", name : "Day off"}
    {code : "off-season", name : "Off season"}
  ]

  $scope.data =
    message : null
    reason : $scope.reasonsList[0]
    openDate : null

  $scope.sendReport = ->
    home = user.getHome().code
    data =
      operate:
        status : $scope.data.reason.code
        openDate : moment($scope.data.openDate).unix() if $scope.data.openDate
      comment : $scope.data.message

    reportsDA.send(home, data).then (res) ->
      $state.go "tab.home"

  $scope.cancelReport = ->
    $state.go "tab.home"

