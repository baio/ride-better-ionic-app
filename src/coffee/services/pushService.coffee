app.factory "pushService", ($rootScope, cordovaPushNotifications, pushConfig, platformsEP, $ionicPopup, user, resources) ->

  showAlert = (msg) ->
    $ionicPopup.alert
      title : resources.str("alert")
      content : msg


  register : ->

    $rootScope.$on "device::push::registered", (evt, platform) ->
      console.log "device::push::registered", platform
      user.registerPlatform platform

    $rootScope.$on "device::push::error", (evt, err) ->
      console.log "device::push::error", err

    $rootScope.$on "device::push::message", (evt, msg) ->
      console.log "device::push::message", msg
      showAlert msg

    cordovaPushNotifications.register(pushConfig.keys)
