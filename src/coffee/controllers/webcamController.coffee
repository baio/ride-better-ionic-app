app.controller "WebcamController", ($scope, webcamsDA, user, notifier) ->

  console.log "Webcam Controller"

  $scope.cards = []
  $scope.currentCard = null

  setWebcam = (res) ->
    #$scope.cards.push(res)
    $scope.cards.splice(0, $scope.cards.length, res)
    res.index = $scope.cards.indexOf res
    $scope.currentCard = res

  loadLatest = ->    
    home = user.getHome()
    webcamsDA.latest(spot : "1936").then (res) ->
      $scope.cards.splice(0, $scope.cards.length)
      setWebcam res

  loadPrev = (index) ->
    if !$scope.cards.length
      loadLatest()
    else
      cur = $scope.cards[index]
      home = user.getHome()
      webcamsDA.prev(spot : "1936", time : $scope.cards[index].created)
      .then setWebcam
      .catch -> notifier.message "No more images, try again later."


  loadNext = (index) ->
   if !$scope.cards.length
      loadLatest()
    else      
      cur = $scope.cards[index]
      home = user.getHome()
      webcamsDA.next(spot : "1936", time : $scope.cards[index].created)
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
