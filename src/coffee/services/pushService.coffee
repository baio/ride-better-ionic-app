app.factory "pushService", ($rootScope, cordovaPushNotifications, pushConfig, platformsEP) ->

  register : ->

    $rootScope.$on "device::push::registered", (evt, platform) ->
      console.log "device::push::registered", platform
      platformsEP.register platform

    $rootScope.$on "device::push::error", (evt, err) ->
      console.log "device::push::error", err

    $rootScope.$on "device::push::message", (evt, msg) ->
      console.log "device::push::message", msg

    cordovaPushNotifications.register(pushConfig.keys)
