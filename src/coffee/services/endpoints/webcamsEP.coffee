app.factory "webcamsEP", (_ep) ->

  latest : (opts) ->

    console.log "webcams::latest", opts

    _ep.get "webcams/" + opts.spot + "/latest"

  prev : (opts) ->

    console.log "webcams::prev", opts

    _ep.get "webcams/" + opts.spot + "/prev/" + opts.time

  next : (opts) ->

    console.log "webcams::next", opts

    _ep.get "webcams/" + opts.spot + "/next/" + opts.time
