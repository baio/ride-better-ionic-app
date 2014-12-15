app.controller "ReportsController", ($scope, homeDA, home) ->

  console.log "Reports Controller"

  setMessages = (data) ->
    if data
      $scope.reports = data.reports

  homeDA.get(spot : home.code, lang : user.getLang(), culture : user.getCulture()).then setMessages
