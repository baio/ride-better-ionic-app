app.factory "_ep", ($q, $http, webApiConfig, authio, notifier) ->

  getAuthHeaders = -> authorization: "Bearer " + authio.getJWT()

  get : (path, qs) ->

    deferred = $q.defer()

    inProgress = false

    if inProgress
      deferred.reject(new Error "In progress")
    else
      notifier.showLoading()
      inProgress = true
      $http.get(webApiConfig.url + path, params : qs)
        .success(deferred.resolve)
        .error(deferred.reject)
        .finally ->
          inProgress = false
          notifier.hideLoading()

    deferred.promise


  post : (path, data, useAuth) ->

    deferred = $q.defer()

    inProgress = false

    if inProgress
      deferred.reject(new Error "In progress")
    else
      notifier.showLoading()
      inProgress = true
      headers = headers : getAuthHeaders() if useAuth
      $http.post(webApiConfig.url + path, data, headers).success (data) ->
        inProgress = false
        deferred.resolve data
      .error (data) ->
        deferred.reject data
      .finally ->
        inProgress = false
        notifier.hideLoading()

    deferred.promise
