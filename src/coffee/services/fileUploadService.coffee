app.factory "fileUploadService", ($q, cordovaFileTransfer, $upload) ->

  upload: (url, file, data, headers, method) ->

    method ?= "post"

    if window.cordova
      cordovaFileTransfer.upload url, file, data, headers
    else
      $upload.upload
        url: url
        method : method
        file: file
        data : data
        headers : headers