app.controller "ReportsController", ($scope, reports, user) ->

  console.log "Reports Controller"

  setMessages = (serviceData) ->
    if serviceData
      $scope.messages = serviceData.messages

  homeCode = user.getHome().code
  reports.get(homeCode).then setMessages
