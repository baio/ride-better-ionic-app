app.controller "PalsController", ($scope, report, user) ->

  console.log "Pals Controller"

  setMessages = (serviceData) ->
    if serviceData
      $scope.messages = serviceData.items

  homeCode = user.getHome().code
  setMessages report.getCache(homeCode)
  report.get(homeCode).then setMessages
