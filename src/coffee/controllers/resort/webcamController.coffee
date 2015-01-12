app.controller "WebcamController", ($scope, webcamsDA, notifier) ->

  console.log "Webcam Controller"

  $scope.current = null
  $scope.data =
    currentItem : null

  setWebcam = (res) ->
    console.log res
    if res.current?.meta
      $scope.current = res.current
      $scope.list = res.list
      $scope.data.currentItem = res.list.filter((f) -> f.index == res.current.index)[0]

  getIndex = ->
    if $scope.data.currentItem then $scope.data.currentItem.index

  $scope.loadLatest = ->
    webcamsDA.latest(spot : "1936", index : getIndex()).then setWebcam

  $scope.loadPrev = ->
    console.log "wtf"
    webcamsDA.prev(spot : "1936", index : getIndex(), time : $scope.current.meta.created)
    .then setWebcam
    .catch -> notifier.message "no_more_images"

  $scope.loadNext = ->
    webcamsDA.next(spot : "1936", index : getIndex(), time : $scope.current.meta.created)
    .then setWebcam
    .catch ->
      notifier.message "no_more_images"

  $scope.loadLatest()

  

