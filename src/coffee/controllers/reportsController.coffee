app.controller "ReportsController", ($scope, homeDA, user) ->

  console.log "Reports Controller"

  setMessages = (data) ->
    if data
      $scope.reports = data.reports

  home = user.getHome()
  homeDA.get(spot : home.code, lang : user.getLang(), culture : user.getCulture()).then setMessages
