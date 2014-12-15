app.controller "WebcamController", ($scope, webcamsDA, home, notifier) ->

  console.log "Webcam Controller"

  $scope.current = null

  setWebcam = (res) ->
    if res.current?.meta
      $scope.current = res.current
      $scope.list = res.list
      $scope.currentItem = res.list.filter((f) -> f.index == res.current.index)[0]    

  getIndex = ->
    if $scope.currentItem then $scope.currentItem.index

  $scope.loadLatest = ->  
    webcamsDA.latest(spot : "1936", index : getIndex()).then setWebcam

  $scope.loadPrev = ->
    webcamsDA.prev(spot : "1936", index : getIndex(), time : $scope.current.meta.created)
    .then setWebcam
    .catch -> notifier.message "No more images, try again later."

  $scope.loadNext = ->
    webcamsDA.next(spot : "1936", index : getIndex(), time : $scope.current.meta.created)
    .then setWebcam
    .catch ->
      notifier.message "No more images, try again later."

  if $scope.$root.activated
    $scope.loadLatest()

  $scope.$on "app.activated", $scope.loadLatest

