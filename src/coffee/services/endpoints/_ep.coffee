app.factory "_ep", ($q, $http, webApiConfig) ->

  get : (path, qs) ->

    deferred = $q.defer()

    inProgress = false

    if inProgress
      deferred.reject(new Error "In progress")
    else
      inProgress = true
      $http.get(webApiConfig.url + path, params : qs).success (data) ->
        inProgress = false
        deferred.resolve data
      .error (data) ->
        inProgress = false
        deferred.reject data

    deferred.promise


  post : (path, data) ->

    deferred = $q.defer()

    inProgress = false

    if inProgress
      deferred.reject(new Error "In progress")
    else
      inProgress = true
      $http.post(webApiConfig.url + path, data).success (data) ->
        inProgress = false
        deferred.resolve data
      .error (data) ->
        inProgress = false
        deferred.reject data

    deferred.promise
