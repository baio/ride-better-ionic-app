app.controller "AddStuffController", ($scope, stateResolved, cameraService, resources, notifier, resortsDA, $state) ->

  console.log "Add Stuff Controller"

  $scope.tagsList = [
    {code : "lift", name : resources.str("Lift Prices")}
    {code : "rent", name : resources.str("Rent Prices")}
    {code : "food", name : resources.str("Food Prices")}
    {code : "service", name : resources.str("Service Prices")}
  ]

  resetScope = ->
    $scope.data =
      photo :
        file : null
        src : null
        url : null
      title : null
      tag : $scope.tagsList[0]

  resetScope()

  $scope.$on '$ionicView.enter', resetScope

  validate = ->
    if !$scope.data.photo.url and !$scope.data.photo.file
      return "Please add some photo"
    if !$scope.data.title
      return "Please add some title"
    if !$scope.data.tag
      return "Please choose some tag"

  getPhoto = (isFromGallery) ->
    notifier.showLoading()
    cameraService.getPicture(isFromGallery).then (pic) ->
      if pic
        $scope.data.photo.file = pic.file
        $scope.data.photo.url = pic.url
        $scope.data.photo.src = pic.url
        notifier.hideLoading()

  $scope.takePhoto = ->
    notifier.showLoading()
    cameraService.takePicture().then (url) ->
      if url
        $scope.data.photo.src = url
        $scope.data.photo.url = url
    .finally ->
      notifier.hideLoading()

  $scope.selectPhoto = ->
    getPhoto(true)

  $scope.cancel = ->
    console.log "cancel"
    $state.transitionTo("root.main.home", {id : stateResolved.spot.id, culture : stateResolved.culture.code})

  $scope.send = ->
    err = validate()
    if err
      notifier.message err
    else
      #cordova required url to file, instead of file
      file = if window.cordova then $scope.data.photo.url else $scope.data.photo.file
      data = title : $scope.data.title, tag : $scope.data.tag.code
      resortsDA.postPrice(stateResolved.spot.id, file, data).then ->
        resetScope()
        notifier.message "Success"
      , (err) ->
        notifier.message "Fail"


  $scope.attachPhoto = (files) ->
    if files.length
      cameraService.getPictureFromFile(files[0]).then (pic) ->
        console.log pic
        $scope.data.photo.file = pic.file
        $scope.data.photo.src = pic.dataUrl
