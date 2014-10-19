app.factory "report", ($q, $http, webApiConfig, user, mapper, cache, authio) ->

  getAuthHeaders = -> authorization: "Bearer " + authio.getJWT()

  latestReportId = null

  getCache : (spot) ->
    cache.get "report." + spot

  get : (spot) ->
    console.log "report::get", spot
    $http.get(webApiConfig.url + "report/#{spot}").then (res) ->
      cache.put "report." + spot, res.data, "eod"
      res.data

  send : (spot, code) ->
    console.log "report::send", spot, code
    user.login(true).then ->
      $http.post(webApiConfig.url + "report/#{spot}/#{code}", null, headers : getAuthHeaders()).then (res) ->
        latestReportId = res.data.id
        mapper.mapReports res.data.report

  addMessage :  (msg) ->
    console.log "report::addMessage", msg
    if latestReportId
      if !msg || msg.length < 3
        $q.reject(new Error "msg length [3, 150]")
      else
        msg = msg.substring(0, 149) if msg.length > 150
        $http.post(webApiConfig.url + "report/#{latestReportId}/message", {text : msg}, headers : getAuthHeaders()).then (res) ->
          latestReportId = null
          res.data
    else
      $q.reject(new Error "No report to add message found")
