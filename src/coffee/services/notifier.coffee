app.factory "notifier", ($ionicPopup, resources, $ionicLoading) ->

  message : (msg) ->

    if window.plugins?.toast
      window.plugins.toast.showLongTop(resources.str(msg))
    else
      $ionicPopup.alert  title : resources.str("alert"), template : resources.str(msg)


  error : (msg) ->
    if window.plugins?.toast
      window.plugins.toast.showLongTop(msg)
    else
      $ionicPopup.alert  title : resources.str("error"), template : resources.str(msg)

  showLoading: ->
    $ionicLoading.show
      templateUrl  : "utils/loading.html"
      noBackdrop : false

  hideLoading: ->
    $ionicLoading.hide()

  notifyNative: (os) ->
    $ionicPopup.confirm(
      title : resources.str("alert")
      template : resources.str("install_native_q")
      okText : resources.str("sure")
      cancelText : resources.str("not_now")
    )


  confirm: (template, okText, cancelText) ->
    okText ?= "yes"
    cancelText ?= "no"
    $ionicPopup.confirm(
      title : resources.str("alert")
      template : resources.str(template)
      okText : resources.str(okText)
      cancelText : resources.str(cancelText)
    )    