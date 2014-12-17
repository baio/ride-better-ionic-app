app.controller "ClosedReportController", ($scope, reportsDA, $state, resources, notifier, user) ->

  console.log "ClosedReportController"

  $scope.reasonsList = [
    {code : "closed", name : resources.str("Unknown")}
    {code : "day-off", name : resources.str("Day off")}
    {code : "off-season", name : resources.str("Off season")}
  ]

  $scope.data =
    message : null
    reason : $scope.reasonsList[0]
    openDate : null

  $scope.sendReport = ->

    openDate = moment.utc($scope.data.openDate, ["YYYY-MM-DD", "DD.MM.YYYY"]) if $scope.data.openDate
    if openDate and !openDate.isValid()
      notifier.error "Date in wrong format"
    data =
      operate:
        status : $scope.data.reason.code
        openDate : openDate.unix() if openDate
      comment : $scope.data.message

    reportsDA.send(user.getHome().code, data).then (res) ->
      $state.go "tab.home"

  $scope.cancelReport = ->
    $state.go "tab.home"

