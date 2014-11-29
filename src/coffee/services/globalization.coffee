app.factory "globalization", ($q, resources, culture) ->

  getLangAndCulture: ->

    _default = lang : "en", culture : "eu"

    deferred = $q.defer()

    if navigator.globalization
      navigator.globalization.getLocaleName (locale) ->
        spts = locale.value.split("-")
        lang = spts[0].toLowerCase()
        cl = if spts.length > 1 then spts[1].toLowerCase() else lang
        deferred.resolve
          lang : resources.getKnownLang lang
          culture : culture.getKnownCulture cl
      , -> deferred.resolve _default
    else
      deferred.resolve _default


    deferred.promise

