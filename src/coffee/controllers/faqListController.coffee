app.controller "FaqListController", ($scope, boardDA, user, $ionicModal, notifier) ->

  console.log "Faq Controller"

  $scope.data = 
      canLoadMore : false
      threads : []

  load = (opts, pushIndex) ->
    home = user.getHome()
    boardDA.get({spot : home.code, board : "faq"}, opts).then (res) -> setItems(res, pushIndex)

  loadMore = ->
    
    last = $scope.data.threads?[$scope.data.threads.length - 1]
    if last
      since = moment.utc(last.created, "X").unix()

    load(since : since).then (res) ->
      $scope.data.canLoadMore = res.hasMore
    .catch ->
        $scope.data.canLoadMore = false
    .finally ->
      $scope.$broadcast('scroll.infiniteScrollComplete')

  pullMore = ->
    first = $scope.data.threads[0]
    if first
      till = moment.utc(first.message.created, "X").unix()
    load(till : till, 0).finally ->
      $scope.$broadcast('scroll.refreshComplete')

  setItems = (data, index) ->
    if data
      if index is undefined
        $scope.data.threads.push data.threads...
      else
        $scope.data.threads.splice index, 0, data.threads...
    data

  $scope.loadMore = loadMore()

  $scope.canRemove = (thread) ->
    user.isUser thread.user

  $scope.removeThread = (thread) ->    
    boardDA.removeThread(thread._id).then ->
      $scope.data.threads.splice $scope.data.threads.indexOf(thread), 1


  # --- Send Message Form ---

  $scope.$on '$destroy', -> $scope.sendMsgModal.remove()

  $ionicModal.fromTemplateUrl('modals/sendMsgForm.html',
    scope: $scope
    animation: 'slide-in-up'
  ).then (modal) ->
    $scope.sendMsgModal = modal

  $scope.openSendMsgModal = (thread) ->
    user.login().then ->
      $scope.sendMsgModal.thread = thread
      $scope.sendMsgModal.show()

  $scope.$on '$destroy', -> $scope.sendMsgModal.remove()

  $scope.sendMessage = ->
    if !$scope.data.newMessage
      notifier.message "Question"
    else
      home = user.getHome().code
      data =
        message : $scope.data.newMessage
      promise = if $scope.sendMsgModal.thread
        boardDA.postReply($scope.sendMsgModal.thread._id, data)
      else
        boardDA.postThread({spot : home, board : "faq"}, data)
      promise .then (res) ->
        $scope.data.threads.splice 0, 0, res
        $scope.newMessage = null
        $scope.sendMsgModal.hide()

  $scope.cancelMessage = ->
    $scope.sendMsgModal.hide()

  # ----
