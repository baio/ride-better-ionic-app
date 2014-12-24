app.controller "ReportsController", ($scope, homeDA, user, spotResolved) ->

  console.log "Reports Controller"

  setMessages = (data) ->
    if data
      $scope.reports = data.reports

  homeDA.get(spot : spotResolved, lang : user.getLang(), culture : user.getCulture()).then setMessages
