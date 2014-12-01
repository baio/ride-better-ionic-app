app.factory "httpFailureInterceptor", ($injector) ->
  (promise) ->
    promise.then null, (err, code) ->
      if err
        if err.status != 404
          notifier = $injector.get("notifier")
          notifier.error "Some error occurred, please try again later."
    promise