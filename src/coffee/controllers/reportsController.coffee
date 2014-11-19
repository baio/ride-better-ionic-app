app.controller "ReportsController", ($scope, homeDA, user) ->

  console.log "Reports Controller"

  setMessages = (data) ->
    if data
      $scope.reports = data.reports

  homeCode = user.getHome().code
  homeDA.get(homeCode, user.getLang()).then setMessages
