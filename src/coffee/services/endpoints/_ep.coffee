app.factory "_ep", ($q, $http, webApiConfig, authio, notifier, fileUploadService) ->
  
  `
    function normalize (str) {
      return str
              .replace(/[\/]+/g, '/')
              .replace(/\/\?/g, '?')
              .replace(/\/\#/g, '#')
              .replace(/\:\//g, '://');
    };

    function urljoin(arr) {
      var joined = arr.join('/');
      return normalize(joined);
    };
  `
  getAuthHeaders = -> authorization: "Bearer " + authio.getJWT()

  save = (method, path, data, useAuth) ->

    deferred = $q.defer()

    inProgress = false

    if inProgress
      deferred.reject(new Error "In progress")
    else
      notifier.showLoading()
      inProgress = true
      headers = headers : getAuthHeaders() if useAuth
      $http[method](webApiConfig.url + path, data, headers).success (data) ->
        inProgress = false
        deferred.resolve data
      .error (data) ->
        deferred.reject data
      .finally ->
        inProgress = false
        notifier.hideLoading()

    deferred.promise

  saveFile = (method, path, file, data, useAuth) ->

    inProgress = false

    if inProgress
      deferred.reject(new Error "In progress")
    else
      notifier.showLoading()
      inProgress = true

    headers = getAuthHeaders() if useAuth

    fileUploadService.upload(webApiConfig.url + path, file, data, headers, method)
    .then (res) ->
      res.data
    .finally ->
      inProgress = false
      notifier.hideLoading()    


  get : (path, qs) ->

    path = urljoin(path) if Array.isArray path

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


  post : (path, data, useAuth) -> save "post", path, data, useAuth

  put : (path, data, useAuth) -> save "put", path, data, useAuth

  remove : (path, useAuth) ->

    deferred = $q.defer()

    inProgress = false

    if inProgress
      deferred.reject(new Error "In progress")
    else
      notifier.showLoading()
      inProgress = true
      headers = headers : getAuthHeaders() if useAuth
      $http.delete(webApiConfig.url + path, headers).success (data) ->
        inProgress = false
        deferred.resolve data
      .error (data) ->
          deferred.reject data
      .finally ->
          inProgress = false
          notifier.hideLoading()

    deferred.promise

  postFile: (path, file, data, useAuth) ->
    saveFile "post", path, file, data, useAuth

  putFile: (path, file, data, useAuth) ->
    saveFile "put", path, file, data, useAuth
