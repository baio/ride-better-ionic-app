app = angular.module("surf-better", [
  "ionic", "ngResource", "angular-data.DSCacheFactory", "fixes", "angular-authio-jwt"
]).run(($ionicPlatform, $rootScope, res, prettifyer, user, authio, authioLogin, mapper) ->

  console.log ">>>app.coffee:5"
  $ionicPlatform.ready ->
    console.log ">>>app.coffee:7"
    authioLogin.activate()
    console.log ">>>app.coffee:9"
    cordova.plugins.Keyboard.hideKeyboardAccessoryBar true  if window.cordova and window.cordova.plugins.Keyboard
    StatusBar.styleDefault() if window.StatusBar
    console.log ">>>app.coffee:10"
    authio.login("facebook").then (res) ->
      console.log ">>>app.coffee:12"
      user.setUser mapper.mapUser(res), true
  user.initialize()
  $rootScope.prettifyer = prettifyer

).config ($stateProvider, $urlRouterProvider) ->

  $stateProvider.state("tab",
    url: "/tab"
    abstract: true
    templateUrl: "tabs/tab.html"
  ).state("tab.home",
    url: "/home",
    views:
      "tab-home":
        templateUrl: "tabs/tab-home.html"
        controller: "HomeController"
  ).state("tab.pals",
    url: "/pals"
    views:
      "tab-home":
        templateUrl: "tabs/tab-pals.html"
        controller: "PalsController"
  ).state("tab.forecast",
    url: "/forecast"
    views:
      "tab-home":
        templateUrl: "tabs/tab-forecast.html"
        controller: "ForecastController"
  ).state("tab.favs",
    url: "/favs"
    views:
      "tab-favs":
        templateUrl: "tabs/tab-favs.html"
        controller: "FavsController"
  ).state("tab.user",
    url: "/user"
    views:
      "tab-user":
        templateUrl: "tabs/tab-user.html"
        controller: "UserController"
  )

  # if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise "/tab/home"
  return

app.constant '$ionicLoadingConfig', template: 'Loading ...'

app.config (DSCacheFactoryProvider) ->
  DSCacheFactoryProvider.setCacheDefaults
    maxAge: 1000 * 60 * 60 * 24
    deleteOnExpire: 'aggressive'
    storageMode: 'localStorage'

app.config (authioLoginProvider, authConfig) ->
  authioLoginProvider.initialize
    oauthio_key : authConfig.oauthio_key
    baseUrl : authConfig.apiUrl
    user : authConfig.user
