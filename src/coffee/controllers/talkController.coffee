app.controller "TalkController", ($scope, talkDA, user, $ionicModal, notifier) ->

  console.log "Talk Controller"

  $scope.data =
    newMessage : null

  setMessages = (data) ->
    if data
      $scope.talk = data

  loadTalk = ->
    home = user.getHome()
    talkDA.get(home.code).then(setMessages)

  if $scope.$root.activated
    loadTalk()

  $scope.$on "app.activated", loadTalk

  $scope.removeThread = (thread) ->
    talkDA.remove(thread._id).then ->
      $scope.talk.threads.splice $scope.talk.threads.indexOf(thread), 1

  $scope.pullTalk = ->
    loadTalk().finally ->
      $scope.$broadcast('scroll.refreshComplete')

  # --- Send Message Form ---

  $ionicModal.fromTemplateUrl( 'modals/sendMsgForm.html',
    scope: $scope
    animation: 'slide-in-up'
  ).then (modal) ->
    $scope.sendMsgModal = modal

  $scope.openSendMsgModal = ->
    $scope.sendMsgModal.show()

  $scope.$on '$destroy', -> $scope.sendMsgModal.remove()

  $scope.sendMessage = ->
    if !$scope.data.newMessage
      notifier.message "Please input some data to send"
    else
      home = user.getHome().code
      data =
        message : $scope.data.newMessage
      talkDA.send(home, data).then (res) ->
        console.log ">>>talkController.coffee:43", res
        $scope.talk ?= {threads : []}
        $scope.talk.threads.splice 0, 0, res
        $scope.newMessage = null
        $scope.sendMsgModal.hide()

  $scope.cancelMessage = ->
    $scope.sendMsgModal.hide()

  # ----
