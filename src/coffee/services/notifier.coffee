app.factory "notifier", ($ionicPopup, res, $ionicLoading) ->

  message : (msg) ->
    if window.plugins?.toast
      window.plugins.toast.showLongTop(msg)
    else
      $ionicPopup.alert  title : res.str("Alert"), template : msg


  error : (msg) ->
    if window.plugins?.toast
      $ionicPopup.alert  title : res.str("Error"), template : msg
    else
      window.plugins.toast.showLongTop(msg)

  showLoading: ->
    $ionicLoading.show
      templateUrl  : "utils/loading.html"
      noBackdrop : true

  hideLoading: ->
    $ionicLoading.hide()