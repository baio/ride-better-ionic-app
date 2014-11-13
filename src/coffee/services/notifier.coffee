app.factory "notifier", ($ionicPopup, res) ->

  message : (msg) ->
    $ionicPopup.alert  title : res.str("Alert"), template : msg

  error : (msg) ->
    $ionicPopup.alert  title : res.str("Error"), template : msg
