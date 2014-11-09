app.controller "ReportsController", ($scope, reportsDA, user) ->

  console.log "Reports Controller"

  setMessages = (data) ->
    if data
      $scope.reports = data

  homeCode = user.getHome().code
  reportsDA.get(homeCode, user.getLang()).then setMessages
