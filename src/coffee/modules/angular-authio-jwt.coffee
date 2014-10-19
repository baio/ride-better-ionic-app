app = angular.module "angular-authio-jwt", ["angular-data.DSCacheFactory"]

###
app.config (DSCacheFactoryProvider) ->
  DSCacheFactoryProvider.setCacheDefaults
    maxAge: 1000 * 60 * 60 * 24
    deleteOnExpire: 'aggressive'
    storageMode: 'localStorage'
###



app.factory "authioEndpoints", ($q, $http) ->

  console.log ">>>angular-authio-jwt.coffee:11"
  _authBaseUrl = null

  setUrl: (url) -> _authBaseUrl = url

  getToken: ->
    $http.get(_authBaseUrl + "oauth/token").then((res) -> res.data)

  signin: (provider, code, token) ->
    data = code : code, provider : provider, token : token
    console.log ">>>angular-authio-jwt.coffee:27"
    $http.post(_authBaseUrl + "oauth/signin", data).then((res) -> res.data)

  user: (jwt) ->
    $http.get(_authBaseUrl + "oauth/user", headers : authorization: "Bearer " + jwt).then (res) -> res.data

  setData: (jwt, key, data) ->
    $http.put(_authBaseUrl + "oauth/data/#{key}", data, headers : authorization: "Bearer " + jwt).then (res) -> res.data

app.provider "authioLogin", ->

  #could hold debug user
  _user = null
  _key = null
  _authBaseUrl = null

  initialize : (opts) ->
    _authBaseUrl = opts.baseUrl
    _user = opts.user
    _key = opts.oauthio_key
    console.log ">>>angular-authio-jwt.coffee:51" + _key

  $get : ($q, authioEndpoints) ->
    popup = (provider, token, opts) ->
      deferred = $q.defer()
      _opts = if opts then angular.copy(opts) else {}
      _opts.state = token
      OAuth.popup(provider, _opts).done(deferred.resolve).fail(deferred.reject)
      deferred.promise

    login : (provider, opts) ->
      if _user
        return $q.when _user
      authioEndpoints.getToken().then (res) ->
        popup(provider, res.token, opts).then (res1) ->
          authioEndpoints.signin(provider, res1.code, res.token)

    logout: (provider) ->
      OAuth.clearCache provider

    activate : ->
      authioEndpoints.setUrl _authBaseUrl
      console.log ">>>angular-authio-jwt.coffee:37" + _key
      OAuth.initialize _key
      console.log ">>>angular-authio-jwt.coffee:38"

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
    jwt = getJWT()
    if !jwt and opts?.force
      promise = $q.when()
      if opts?.confirm then promise = opts.confirm()
      promise.then ->
        authioLogin.login(provider, opts).then (res) ->
          setJWT res.token
          authioLogin.logout provider
          res
    else if jwt
      authioEndpoints.user(jwt).catch ->
        setJWT undefined
        login(provider, opts)
    else
      $q.reject new Error("Token not found")

  setData : (key, data) ->
    jwt = getJWT()
    if jwt
      authioEndpoints.setData jwt, key, data
    else
      $q.reject new Error status : 401


  login : login

  logout: ->
    setJWT undefined

  getJWT: getJWT
