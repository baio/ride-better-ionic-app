app.factory "fileUploadService", ($q, cordovaFileTransfer, $upload) ->

  upload: (url, file, data, headers) ->

    console.log url
    console.log file
    console.log data

    if window.cordova
      cordovaFileTransfer.upload url, file, data, headers
    else
      $upload.upload
        url: url
        method : "post"
        file: file
        data : data
        headers : headers