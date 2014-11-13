app.factory "httpFailureInterceptor", ($injector, res) ->
  (promise) ->
    promise.then null, (err) ->
      console.log ">>>httpFailureInterceptor.coffee:5"
      if err
        notifier = $injector.get("notifier")
        console.log ">>>httpFailureInterceptor.coffee:7",
        notifier.error res.str "Some error occurred, please try again later."
    promise