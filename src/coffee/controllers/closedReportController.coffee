app.controller "ClosedReportController", ($scope, reportsDA, user, $state, res) ->

  console.log "ClosedReportController"

  $scope.reasonsList = [
    {code : "closed", name : res.str("Unknown")}
    {code : "day-off", name : res.str("Day off")}
    {code : "off-season", name : res.str("Off season")}
  ]

  $scope.data =
    message : null
    reason : $scope.reasonsList[0]
    openDate : null

  $scope.sendReport = ->
    home = user.getHome().code

    openDate = moment.utc($scope.data.openDate, ["YYYY-MM-DD", "DD.MM.YYYY"]) if $scope.data.openDate
    console.log ">>>closedReportController.coffee:18", openDate
    data =
      operate:
        status : $scope.data.reason.code
        openDate : openDate.unix() if openDate and openDate.isValid()
      comment : $scope.data.message

    reportsDA.send(home, data).then (res) ->
      $state.go "tab.home"

  $scope.cancelReport = ->
    $state.go "tab.home"

