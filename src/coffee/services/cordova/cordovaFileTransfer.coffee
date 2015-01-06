app.factory "cordovaFileTransfer", ($q) ->

  upload: (url, fileURL, data, headers) ->
    options = new FileUploadOptions();
    options.fileKey = "file"
    options.fileName = fileURL.substr(fileURL.lastIndexOf('/') + 1);
    options.mimeType = "text/plain";

    options.params = data
    options.headers = headers

    console.log options.fileName

    deferred = $q.defer()
    win = (res) -> deferred.resolve res
    fail = (err) -> deferred.reject err
    ft = new FileTransfer()
    ft.upload fileURL, encodeURI(url), win, fail, options
    deferred.promise