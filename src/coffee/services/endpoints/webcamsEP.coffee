app.factory "webcamsEP", (_ep) ->

  latest : (opts) ->

    console.log "webcams::latest", opts

    _ep.get ["webcams", opts.spot, opts.index, "latest"], nostream : opts.nostream

  prev : (opts) ->

    console.log "webcams::prev", opts

    _ep.get "webcams/" + opts.spot + "/" + opts.index +  "/prev/" + opts.time, nostream : opts.nostream

  next : (opts) ->

    console.log "webcams::next", opts

    _ep.get "webcams/" + opts.spot + "/" + opts.index +  "/next/" + opts.time, nostream : opts.nostream
