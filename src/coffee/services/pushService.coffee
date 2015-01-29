app.factory "pushService", (cordovaPushNotifications, pushConfig, user, $q) ->

  register : ->

    deferred = $q.defer()

    onRegistered = (id, platform) ->
      deferred.resolve(key : id, platform : platform)

    onMsg = (msg) -> alert msg.message
    onError = (err) ->
      deferred.reject err

    cordovaPushNotifications.register pushConfig, onRegistered, onMsg, onError

    deferred.promise
