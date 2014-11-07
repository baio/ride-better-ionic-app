app.factory "spotsEP", (_ep) ->


  get : (term, geo) ->

    _ep.get "spots", term : term, geo : geo
