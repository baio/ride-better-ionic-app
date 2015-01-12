app.controller "AddStuffController", ($scope, stateResolved, imageService, resources, notifier, resortsDA, $state) ->

  console.log "Add Stuff Controller"

  $scope.tagsList = [
    {code : "lift", name : resources.str("lift_prices")}
    {code : "rent", name : resources.str("rent_prices")}
    {code : "food", name : resources.str("food_prices")}
    {code : "service", name : resources.str("rent_prices")}
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
      return "photo_required"
    if !$scope.data.title
      return "title_required"
    if !$scope.data.tag
      return "tag_required"

  getPhoto = (isFromGallery) ->
    notifier.showLoading()
    imageService.takePicture(isFromGallery).then (url) ->
      if url
        $scope.data.photo.src = url
        $scope.data.photo.url = url
    .finally ->
        notifier.hideLoading()

  $scope.takePhoto = ->
    getPhoto(false)

  $scope.selectPhoto = ->
    getPhoto(true)

  $scope.cancel = ->
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
        notifier.message "success"
      , (err) ->
        notifier.message "fail"


  $scope.attachPhoto = (files) ->
    if files.length
      imageService.getPictureFromFile(files[0]).then (pic) ->
        $scope.data.photo.file = pic.file
        $scope.data.photo.src = pic.dataUrl
