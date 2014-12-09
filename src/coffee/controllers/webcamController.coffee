app.controller "WebcamController", ($scope, webcamsDA, user, notifier) ->

  console.log "Webcam Controller"

  $scope.current = null

  setWebcam = (res) ->
    $scope.current = res.current
    $scope.list = res.list
    $scope.currentItem = res.list.filter((f) -> f.index == res.current.index)[0]
    console.log $scope.list, $scope.currentItem

  getIndex = ->  if $scope.currentItem then $scope.currentItem.index else 0

  $scope.loadLatest = ->
    home = user.getHome()
    webcamsDA.latest(spot : "1936", index : getIndex()).then setWebcam

  $scope.loadPrev = ->
    home = user.getHome()
    webcamsDA.prev(spot : "1936", index : getIndex(), time : $scope.current.created)
    .then setWebcam
    .catch -> notifier.message "No more images, try again later."

  $scope.loadNext = ->
    home = user.getHome()
    webcamsDA.next(spot : "1936", index : getIndex(), time : $scope.current.created)
    .then setWebcam
    .catch ->
      notifier.message "No more images, try again later."

  if $scope.$root.activated
    $scope.loadLatest()

  $scope.$on "app.activated", $scope.loadLatest

