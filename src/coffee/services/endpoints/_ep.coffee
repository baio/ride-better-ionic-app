app.factory "_ep", ($q, $http, webApiConfig, authio) ->

  getAuthHeaders = -> authorization: "Bearer " + authio.getJWT()

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


  post : (path, data, useAuth) ->

    deferred = $q.defer()

    inProgress = false

    if inProgress
      deferred.reject(new Error "In progress")
    else
      inProgress = true
      headers = headers : getAuthHeaders() if useAuth
      $http.post(webApiConfig.url + path, data, headers).success (data) ->
        inProgress = false
        deferred.resolve data
      .error (data) ->
        inProgress = false
        deferred.reject data

    deferred.promise
