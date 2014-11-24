app.controller "TalkController", ($scope, talkDA, user, $ionicModal, notifier) ->

  console.log "Talk Controller"

  $scope.data =
    newMessage : null
    canLoadMore : true
  $scope.talk = threads : []

  setMessages = (data, index) ->
    if data
      console.log ">>>talkController.coffee:12", index
      if index is undefined
        console.log ">>>talkController.coffee:14"
        $scope.talk.threads.push data.threads...
      else
        console.log ">>>talkController.coffee:17"
        $scope.talk.threads.splice index, 0, data.threads...
    data

  loadTalk = (opts, pushIndex) ->
    home = user.getHome()
    talkDA.get(home.code, opts).then (res) -> setMessages(res, pushIndex)

  loadMore = ->
    last = $scope.talk?.threads[$scope.talk.threads.length - 1]
    if last
      since = moment.utc(last.message.created, "X").unix()

    loadTalk(since : since).then (res) ->
      $scope.data.canLoadMore = res.hasMore
    .catch ->
        $scope.data.canLoadMore = false
    .finally ->
      $scope.$broadcast('scroll.infiniteScrollComplete')

  pullMore = ->
    first = $scope.talk?.threads[0]
    if first
      till = moment.utc(first.message.created, "X").unix()
    loadTalk(till : till, 0).finally ->
      $scope.$broadcast('scroll.refreshComplete')

  $scope.removeThread = (thread) ->
    talkDA.remove(thread._id).then ->
      $scope.talk.threads.splice $scope.talk.threads.indexOf(thread), 1

  $scope.pullMore = pullMore

  $scope.loadMore = ->
    if $scope.$root.activated
      loadMore()
    else
      $scope.$on "app.activated", loadMore

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
