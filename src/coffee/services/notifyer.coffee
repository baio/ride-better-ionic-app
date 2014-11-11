app.factory "notifyer", ($ionicPopup) ->

  message : (msg) ->
    $ionicPopup.alert  title : "Alert", template : msg

