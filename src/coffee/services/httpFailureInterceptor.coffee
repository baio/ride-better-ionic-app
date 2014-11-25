app.factory "httpFailureInterceptor", ($injector) ->
  (promise) ->
    promise.then null, (err) ->
      if err
        notifier = $injector.get("notifier")
        notifier.error "Some error occurred, please try again later."
    promise