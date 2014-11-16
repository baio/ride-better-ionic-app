app.factory "httpFailureInterceptor", ($injector, res) ->
  (promise) ->
    promise.then null, (err) ->
      if err
        notifier = $injector.get("notifier")
        notifier.error res.str "Some error occurred, please try again later."
    promise