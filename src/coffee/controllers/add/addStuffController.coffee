app.controller "AddStuffController", ($scope, stateResolved, cameraService, resources, notifier, resortsDA) ->

  console.log "Add Stuff Controller !"

  $scope.tagsList = [
    {code : "lift", name : resources.str("Lift Prices")}
    {code : "rent", name : resources.str("Rent Prices")}
    {code : "food", name : resources.str("Food Prices")}
    {code : "service", name : resources.str("Service Prices")}
  ]

  $scope.data =
    photo :
      file : null
      src : null
    title : null
    tag : $scope.tagsList[0]

  validate = ->
    if !$scope.data.photo.file
      return "Please add some photo"
    if !$scope.data.title
      return "Please add some title"
    if !$scope.data.tag
      return "Please choose some tag"

  $scope.cancel = ->
    console.log "cancel"

  $scope.send = ->
    err = validate()
    if err
      notifier.message err
    else
      data = title : $scope.data.title, tag : $scope.data.tag.code
      resortsDA.postPrice(stateResolved.spot.id, $scope.data.photo.file, data).then ->
        console.log "success !!!"
      , (err) ->
        console.log "fail !!!"

  $scope.getPhoto = ->
    cameraService.getPicture().then (pic) ->
      if pic
        console.log "getPhoto"
        console.log pic.dataUrl
        $scope.data.photo.file = pic.file
        $scope.data.photo.src = pic.dataUrl

  $scope.attachPhoto = (files) ->
    if files.length
      cameraService.getPictureFromFile(files[0]).then (pic) ->
        $scope.data.photo.file = pic.file
        $scope.data.photo.src = pic.dataUrl
