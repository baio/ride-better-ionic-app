app.factory "snapshotEP", (_ep) ->

  get : (spot, lang) ->

    console.log "snapshot::get", spot, lang

    _ep.get "snapshot/" + spot, lang : lang
