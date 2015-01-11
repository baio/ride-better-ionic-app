app.factory "cordovaCamera", ($q) ->

  getFile = (fileEntry) ->
    deferred = $q.defer()
    fileEntry.file deferred.resolve, deferred.reject
    deferred.promise

  getFileEntry = (url) ->
    deferred = $q.defer()
    window.resolveLocalFileSystemURL url, deferred.resolve, deferred.reject
    deferred.promise

  takePicture = (isFromGallery) ->
    console.log isFromGallery
    pictureSourceType = if isFromGallery then Camera.PictureSourceType.PHOTOLIBRARY else Camera.PictureSourceType.CAMERA
    deferred = $q.defer()
    opts =
      destinationType: Camera.DestinationType.FILE_URL
      sourceType : pictureSourceType
      encodingType : Camera.EncodingType.JPEG
      quality : 50
    navigator.camera.getPicture deferred.resolve, deferred.reject, opts
    deferred.promise

  takePicture: takePicture

  getPictureFile: (isFromGallery) ->
    if window.cordova
      takePicture(isFromGallery)
      .then (url) ->
        getFileEntry(url).then (fileEntry) -> [url, fileEntry]
      .then (res) ->
        getFile(res[1]).then (file) -> [res[0], file]
      .then (res) ->
        url : res[0]
        file : res[1]
    else
      $q.reject(new Error "Skip getPicture since in browser")



