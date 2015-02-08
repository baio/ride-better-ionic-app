app.factory "platformsEP", (_ep) ->

  register: (platform) ->

    _ep.post "platforms/" + platform.platform + "/" + platform.token
