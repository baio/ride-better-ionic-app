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
      noBackdrop : true

  hideLoading: ->
    $ionicLoading.hide()