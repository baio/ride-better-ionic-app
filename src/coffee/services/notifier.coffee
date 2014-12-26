app.factory "notifier", ($ionicPopup, resources, $ionicLoading) ->

  message : (msg) ->

    if window.plugins?.toast
      window.plugins.toast.showLongTop(resources.str(msg))
    else
      $ionicPopup.alert  title : resources.str("Alert"), template : resources.str(msg)


  error : (msg) ->
    if window.plugins?.toast
      window.plugins.toast.showLongTop(msg)
    else
      $ionicPopup.alert  title : resources.str("Error"), template : resources.str(msg)

  showLoading: ->
    $ionicLoading.show
      templateUrl  : "utils/loading.html"
      noBackdrop : false

  hideLoading: ->
    $ionicLoading.hide()

  notifyNative: (os) ->
    $ionicPopup.confirm(
      title : resources.str("Alert")
      template : resources.str("Would you like to install native app?")
      okText : resources.str("Sure")
      cancelText : resources.str("Not Now")
    )


  confirm: (template, okText, cancelText) ->
    okText ?= "Yes"
    cancelText ?= "No"
    $ionicPopup.confirm(
      title : resources.str("Alert")
      template : resources.str(template)
      okText : resources.str(okText)
      cancelText : resources.str(cancelText)
    )    