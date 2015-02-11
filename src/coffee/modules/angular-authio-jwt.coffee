app = angular.module "angular-authio-jwt", ["angular-data.DSCacheFactory"]

app.factory "authioEndpoints", ($q, $http) ->

  _authBaseUrl = null

  setUrl: (url) -> _authBaseUrl = url

  getToken: ->
    $http.get(_authBaseUrl + "oauth/token").then((res) -> res.data)

  signin: (data) ->
    $http.post(_authBaseUrl + "oauth/signin", data).then((res) -> res.data)

  user: (jwt) ->
    $http.get(_authBaseUrl + "oauth/user", headers : authorization: "Bearer " + jwt).then (res) -> res.data

  setData: (jwt, key, data) ->
    $http.put(_authBaseUrl + "oauth/data/#{key}", data, headers : authorization: "Bearer " + jwt).then (res) -> res.data

  setPlatform: (jwt, key, platform) ->
    $http.put(_authBaseUrl + "oauth/platform/#{key}", platform, headers : authorization: "Bearer " + jwt).then (res) -> res.data

app.provider "authioLogin", ->

  #could hold debug user
  _user = null
  _key = null
  _authBaseUrl = null
  _token = null

  initialize : (opts) ->
    _authBaseUrl = opts.baseUrl
    _user = opts.user
    _key = opts.oauthio_key

  $get : ($q, authioEndpoints, $rootScope) ->

    activate = ->
      if _authBaseUrl and _key
        authioEndpoints.setUrl _authBaseUrl
        OAuth.initialize _key
        _key = null

    popup = (provider, opts) ->
      deferred = $q.defer()
      if _token
        _opts = if opts then angular.copy(opts) else {}
        _opts.state = _token
        OAuth.popup(provider, _opts).then (res) ->
          token = _token
          _token = null
          deferred.resolve code : res.code, token : token, provider : provider, platform : opts.platform
        , deferred.reject
      else
        deferred.reject new Error "Token not found, invoke requestToken first"
      deferred.promise

    login : (provider, opts) ->
      #return `dev` user if exists
      if _user
        return $q.when _user
      activate()      
      popup(provider, opts)
      .then authioEndpoints.signin
      .then (res) ->
        $rootScope.$broadcast "authioLogin::login", res

    requestToken: ->
      if _authBaseUrl
        activate()
        authioEndpoints.getToken().then (res) ->
          _token = res.token
      else
        $q.reject new Error "authBaseUrl not defined"

    logout: (provider) ->
      activate()
      OAuth.clearCache provider

    getUser: (jwt) ->
      activate()
      authioEndpoints.user(jwt)

    setData: (jwt, key, data) ->
      #return `dev` user if exists
      if _user
        console.log ">>>angular-authio-jwt.coffee:82", "`dev` mode, setData ignored"
        return
      activate()
      authioEndpoints.setData jwt, key, data

app.factory "authio", ($q, DSCacheFactory, authioLogin, authioEndpoints) ->

  cache = DSCacheFactory("authioCache")

  getJWT = ->
    cache.get "_jwt"

  setJWT = (jwt) ->
    if jwt
      cache.put "_jwt", jwt
    else
      cache.remove "_jwt", jwt

  login = (provider, opts) ->
    console.log opts
    jwt = getJWT()
    if !jwt and opts.force
      authioLogin.login(provider, opts).then (res) ->
        setJWT res.token
        res
    else if jwt
      authioLogin.getUser(jwt).catch (e) ->
        setJWT undefined
        $q.reject e
    else
      $q.reject new Error("Token not found")

  setData : (key, data) ->
    jwt = getJWT()
    if jwt
      authioLogin.setData jwt, key, data
    else
      $q.reject new Error status : 401

  setPlatform : (key, platform) ->
    jwt = getJWT()
    if jwt
      authioLogin.setPlatform jwt, key, platform
    else
      $q.reject new Error status : 401

  preLogin: ->
    authioLogin.requestToken()

  login : login

  logout: ->
    setJWT undefined

  getJWT: getJWT

  isLogined: -> getJWT()




