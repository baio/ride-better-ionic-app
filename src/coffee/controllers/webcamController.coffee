app.controller "WebcamController", ($scope, webcamsDA, user, notifier) ->

  console.log "Webcam Controller"

  $scope.cards = []

  $scope.cardSwipedLeft = (index) ->

  $scope.cardSwipedRigth = (index) ->

  setWebcam = (res) ->
    $scope.cards.push(res)
    res.index = $scope.cards.indexOf res

  loadLatest = ->
    home = user.getHome()
    home.code = "1936"
    webcamsDA.latest(spot : home.code).then setWebcam

  loadPrev = (index) ->
    cur = $scope.cards[index]
    home = user.getHome()
    home.code = "1936"
    webcamsDA.prev(spot : home.code, time : $scope.cards[index].created)
    .then setWebcam
    .catch -> notifier.message "No more images, try again later."


  loadNext = (index) ->
    cur = $scope.cards[index]
    home = user.getHome()
    home.code = "1936"
    webcamsDA.next(spot : home.code, time : $scope.cards[index].created)
    .then setWebcam
    .catch ->
      setWebcam cur
      notifier.message "No more images, try again later."


  if $scope.$root.activated
    loadLatest()

  $scope.$on "app.activated", loadLatest

  $scope.cardSwipedLeft = (index) ->
    loadPrev(index)

  $scope.cardSwipedRight = (index) ->
    loadNext(index)

  $scope.cardDestroyed = (index) ->
    console.log ">>>webcamController.coffee:49", index
    $scope.cards.splice(index, 1)

