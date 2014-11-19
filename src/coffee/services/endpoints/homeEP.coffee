app.factory "homeEP", (_ep) ->

  get : (spot, lang) ->

    console.log "home::get", spot, lang

    _ep.get "home/" + spot, lang : lang
