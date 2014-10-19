app.controller "HomeController", ($scope, $ionicModal, snapshot, user, res) ->

  console.log "Home Controller"

  $scope.data =
    message : ""

  # modals

  #addMessage

  $ionicModal.fromTemplateUrl( 'modals/addMessage.html',
    scope: $scope
    animation: 'slide-in-up'
  ).then (modal) ->
    $scope.addMessageModal = modal

  $scope.closeAddMessageModal = ->
    $scope.addMessageModal.hide()

  $scope.$on '$destroy', -> $scope.addMessageModal.remove()

  #defMsgList

  $scope.defMsgList = [res.str.coldwater, res.str.crowdalert, res.str.eventalert, res.str.strongwaves, res.str.weakwaves].map (m) ->
    text : m, selected : false

  $ionicModal.fromTemplateUrl( 'modals/defMsgList.html',
    scope: $scope
    animation: 'slide-in-up'
  ).then (modal) ->
    $scope.defMsgListModal = modal

  $scope.openDefMsgListModal = ->
    $scope.defMsgListModal.show()

  $scope.closeDefMsgListModal = ->
    msg = if $scope.data.message then $scope.data.message else ""
    $scope.data.message = (if msg then (msg + ", ")  else "") +
      $scope.defMsgList.filter((f) -> f.selected and msg.indexOf(f.text) == -1).map((m) -> m.text).join(", ")
    $scope.defMsgListModal.hide()

  $scope.cancelDefMsgListModal = ->
    $scope.defMsgListModal.hide()

  $scope.$on '$destroy', -> $scope.defMsgListModal.remove()

  # end of modals

  setSnapshot = (serviceData) ->
    if serviceData
      $scope.report = serviceData.report
      $scope.forecast =  serviceData.forecast

  home = user.getHome()

  if home
    snapshot.get(home.code).then setSnapshot

  $scope.$on "user.changed", ->
    snapshot.get(user.getHome().code).then setSnapshot

  $scope.sendReport = (reportCode) ->
    home = user.getHome().code
    report.send(home, reportCode).then (res) ->
      #home could be changed during login
      if user.getHome().code == home
        $scope.report = res
      else
        setInstantReport(forecast.getInstantReportCache(user.getHome().code))
      $scope.addMessageModal.show()

  $scope.addReportMessage = (message) ->
    report.addMessage(message).then ->
      $scope.closeAddMessageModal()
    , (err) ->
      $scope.closeAddMessageModal()



