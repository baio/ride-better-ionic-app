app.factory "globalization", ($q) ->

  getLangAndCulture: ->

    deferred = $q.defer()

    if navigator.globalization
      navigator.globalization.getLocaleName (locale) ->
        spts = locale.value.split("-")
        deferred.resolve
          lang : spts[0].toLocaleString()
          culture : spts[1].toLocaleString()
      , deferred.reject
    else
      deferred.resolve
        lang : "en"
        culture : "eu"

    deferred.promise

