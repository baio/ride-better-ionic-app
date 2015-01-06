app.factory "cameraService", ($q) ->

  getFile = (fileEntry) ->
    deferred = $q.defer()
    fileEntry.file deferred.resolve, deferred.reject
    deferred.promise

  getFileEntry = (url) ->
    deferred = $q.defer()
    window.resolveLocalFileSystemURL url, deferred.resolve, deferred.reject
    deferred.promise

  takePicture = (isFromGallery) ->
    pictureSourceType = if isFromGallery then Camera.PictureSourceType.SAVEDPHOTOALBUM else Camera.PictureSourceType.CAMERA
    deferred = $q.defer()
    navigator.camera.getPicture deferred.resolve, deferred.reject, { destinationType: Camera.DestinationType.FILE_URL, sourceType : pictureSourceType }
    deferred.promise

  readAsDataUrl = (file) ->
    deferred = $q.defer()
    fileReader = new FileReader()
    fileReader.onloadend = (evt) -> deferred.resolve evt.target.result
    fileReader.onerror = (err) -> deferred.reject err
    fileReader.readAsDataURL file
    deferred.promise

  getPicture: (isFromGallery) ->
    if window.cordova
      takePicture(isFromGallery)
      .then (url) ->
        getFileEntry(url).then (fileEntry) -> [url, fileEntry]
      .then (res) ->
        getFile(res[1]).then (file) -> [res[0], file]
      .then (res) ->
        readAsDataUrl(res[1]).then (dataUrl) -> [res[0], res[1], dataUrl]
      .then (res) ->
        url : res[0]
        file : res[1]
        dataUrl : res[2]
    else
      $q.reject(new Error "Skip getPicture since in browser")

  getPictureFromFile: (file) ->
    readAsDataUrl(file).then (dataUrl) ->
      file : file
      dataUrl : dataUrl






