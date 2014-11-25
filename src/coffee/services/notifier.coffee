app.factory "notifier", ($ionicPopup, res, $ionicLoading) ->

  message : (msg) ->
    if window.plugins?.toast
      window.plugins.toast.showLongTop(res.str(msg))
    else
      $ionicPopup.alert  title : res.str("Alert"), template : res.str(msg)


  error : (msg) ->
    if window.plugins?.toast
      window.plugins.toast.showLongTop(msg)
    else
      $ionicPopup.alert  title : res.str("Error"), template : res.str(msg)

  showLoading: ->
    $ionicLoading.show
      templateUrl  : "utils/loading.html"
      noBackdrop : true

  hideLoading: ->
    $ionicLoading.hide()