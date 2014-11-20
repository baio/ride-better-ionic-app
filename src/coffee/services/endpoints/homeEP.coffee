app.factory "homeEP", (_ep) ->

  get : (opts) ->

    console.log "home::get", opts

    _ep.get "home/" + opts.spot, lang : opts.lang, culture : opts.culture
