app.factory "notifier", ($ionicPopup, res, $ionicLoading) ->

  message : (msg) ->
    $ionicPopup.alert  title : res.str("Alert"), template : msg

  error : (msg) ->
    $ionicPopup.alert  title : res.str("Error"), template : msg

  showLoading: ->
    $ionicLoading.show
      templateUrl  : "utils/loading.html"
      noBackdrop : true

  hideLoading: ->
    $ionicLoading.hide()