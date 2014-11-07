app.factory "snapshotEP", (_ep) ->

  get : (spot) ->

    console.log "snapshot::get", spot

    _ep.get "snapshot/" + spot
