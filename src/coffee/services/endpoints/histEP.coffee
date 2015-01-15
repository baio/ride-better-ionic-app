app.factory "histEP", (_ep) ->

  getSnowfall : (spots) ->

    console.log "hist::getSnowfall", spots

    _ep.get "spots/" + spots + "/snowfall-history"
