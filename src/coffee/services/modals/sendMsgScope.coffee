app.service "sendMsgFormScope", (resources, imageService, notifier) ->

  scope =
    priority : null
    prioritiesList : [
      {code : "important", name : resources.str("Important")}
      {code : "normal", name : resources.str("Normal")}
    ]
    photo :
      src : null
      url : null
      dataUrl : null

  getPhoto = (isFromGallery) ->
    notifier.showLoading()
    imageService.takePicture(isFromGallery).then (url) ->
      if url
        scope.photo.src = url
        scope.photo.url = url
    .finally ->
        notifier.hideLoading()

  scope.validate = ->
    if !scope.message
      return "Please add some message"

  scope.reset = ->
    scope.photo =
        file : null
        src : null
        url : null
    scope.message = null
    scope.priority = null

  scope.takePhoto = ->
    getPhoto(false)

  scope.selectPhoto = ->
    getPhoto(true)

  scope.attachPhoto = (files) ->
    if files.length
      imageService.getPictureFromFile(files[0]).then (pic) ->
        scope.photo.file = pic.file
        scope.photo.src = pic.dataUrl

  scope.getSendThreadData = ->
    data = 
      message : scope.message
      img : scope.photo     
    if scope.priority and scope.priority.code != "normal"
      data.meta =
        priority : scope.priority.code
    data

  scope : scope
