app.factory "notifyer", ($cordovaToast, $ionicPopup) ->

  message : (msg) ->
    $ionicPopup.alert  title : "Alert", template : msg

