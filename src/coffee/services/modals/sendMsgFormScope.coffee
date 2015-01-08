app.service "sendMsgFormScope", (resources, imageService, notifier) ->

  scope =
    data : 
      message : null
      priority : null
      photo :
        src : null
        url : null
        dataUrl : null
    prioritiesList : [
      {code : "important", name : resources.str("Important")}
      {code : "normal", name : resources.str("Normal")}
    ]

  getPhoto = (isFromGallery) ->
    notifier.showLoading()
    imageService.takePicture(isFromGallery).then (url) ->
      if url
        scope.photo.src = url
        scope.photo.url = url
    .finally ->
        notifier.hideLoading()

  scope.validate = ->
    if !scope.data.message
      return "Please add some message"

  scope.reset = ->
    scope.data =
      message : null
      priority : null
      photo :
        src : null
        url : null
        dataUrl : null

  scope.takePhoto = ->
    getPhoto(false)

  scope.selectPhoto = ->
    getPhoto(true)

  scope.attachPhoto = (files) ->
    if files.length
      imageService.getPictureFromFile(files[0]).then (pic) ->
        scope.data.photo.file = pic.file
        scope.data.photo.src = pic.dataUrl

  scope.removePhoto = (files) ->
    scope.data.photo = 
      file : null
      url : null
      src : null
    
  scope.getSendThreadData = ->
    data = 
      message : scope.data.message
      img : scope.data.photo
    if scope.data.priority and scope.data.priority.code != "normal"
      data.meta =
        priority : scope.data.priority.code
    data

  scope : scope
