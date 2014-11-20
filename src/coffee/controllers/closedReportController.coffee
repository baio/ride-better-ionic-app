app.controller "ClosedReportController", ($scope, reportsDA, user, $state, res, notifier) ->

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
    if openDate and !openDate.isValid()
      notifier.error "Date in wrong format"
    data =
      operate:
        status : $scope.data.reason.code
        openDate : openDate.unix() if openDate
      comment : $scope.data.message

    reportsDA.send(home, data).then (res) ->
      $state.go "tab.home"

  $scope.cancelReport = ->
    $state.go "tab.home"

