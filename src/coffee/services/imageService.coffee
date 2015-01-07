app.factory "imageService", ($q, cordovaCamera) ->

  readAsDataUrl = (file) ->
    deferred = $q.defer()
    fileReader = new FileReader()
    fileReader.onloadend = (evt) -> deferred.resolve evt.target.result
    fileReader.onerror = (err) -> deferred.reject err
    fileReader.readAsDataURL file
    deferred.promise

  takePicture: (isFromGallery) ->
    console.log "Alert: getPictureFile intended to be used in cordova apps"
    cordovaCamera.takePicture isFromGallery

  getPictureFile: (isFromGallery) ->
    console.log "Alert: getPictureFile intended to be used in cordova apps"
    cordovaCamera.getPictureFile(isFromGallery)
    .then (res) ->
      readAsDataUrl(res.url).then (dataUrl) ->
        url : res.url
        file : res.file
        dataUrl : dataUrl

  getPictureFromFile: (file) ->
    readAsDataUrl(file).then (dataUrl) ->
      file : file
      dataUrl : dataUrl






