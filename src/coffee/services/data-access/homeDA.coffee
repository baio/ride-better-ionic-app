app.factory "homeDA", (homeEP, $q, threadsPoolService) ->

  mapHome = (home) ->
    home.reports ?= []
    home.latestImportant ?= []
    home.reports =  threadsPoolService.push home.reports
    home.latestImportant = threadsPoolService.push home.latestImportant
    home.snapshot.lastImportant = home.latestImportant[0]
    home

  get : (opts) ->
    homeEP.get(opts).then mapHome
