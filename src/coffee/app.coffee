app = angular.module("ride-better", [
  "ionic", "angular-data.DSCacheFactory", "fixes", "angular-authio-jwt", "angularMoment", 'ionic.contrib.ui.tinderCards'
]).run(($ionicPlatform, $rootScope, user) ->
  $ionicPlatform.ready ->
    StatusBar.styleDefault() if window.StatusBar
    user.activate().then ->
      $rootScope.activated = true
      $rootScope.$broadcast("app.activated")
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
  ).state("tab.report",
    url: "/report"
    views:
      "tab-home":
        templateUrl: "tabs/tab-send-report.html"
        controller: "SendReportController"
  ).state("tab.closed",
    url: "/closed"
    views:
      "tab-home":
        templateUrl: "tabs/tab-closed-report.html"
        controller: "ClosedReportController"
  ).state("tab.reports",
    url: "/reports"
    views:
      "tab-home":
        templateUrl: "tabs/tab-reports.html"
        controller: "ReportsController"
  ).state("tab.talk",
    url: "/talk"
    views:
      "tab-home":
        templateUrl: "tabs/talks/tab-index.html"
  ).state("tab.talk-today",
    url: "/talk/today"
    views:
      "tab-home":
        templateUrl: "tabs/talks/tab-today.html"
        controller: "TalkController"
  ).state("tab.forecast",
    url: "/forecast"
    views:
      "tab-home":
        templateUrl: "tabs/tab-forecast.html"
        controller: "ForecastController"
  ).state("tab.webcam",
    url: "/webcam"
    views:
      "tab-webcam":
        templateUrl: "tabs/tab-webcam.html"
        controller: "WebcamController"
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

app.config (DSCacheFactoryProvider) ->
  DSCacheFactoryProvider.setCacheDefaults
    maxAge: 1000 * 60 * 60 * 24 * 100
    deleteOnExpire: 'aggressive'
    storageMode: 'localStorage'

app.config (authioLoginProvider, authConfig) ->
  authioLoginProvider.initialize
    oauthio_key : authConfig.oauthio_key
    baseUrl : authConfig.apiUrl
    user : authConfig.user

app.constant "angularMomentConfig",
  preprocess: 'unix'

app.config ($httpProvider) ->
  $httpProvider.responseInterceptors.push "httpFailureInterceptor"

