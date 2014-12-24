app = angular.module("ride-better", [
  "ionic", "angular-data.DSCacheFactory", "angular-authio-jwt", "angularMoment", 'googlechart'
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
    resolve:
      home: (user) ->
        user.getHomeAsync()
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
  ).state("tab.snowHist",
    url: "/snow-hist"
    views:
      "tab-home":
        templateUrl: "tabs/tab-snow-hist.html"
        controller: "SnowHistController"
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
  ).state("tab.info",
    url: "/info"
    views:
      "tab-home":
        templateUrl: "tabs/info/tab-index.html"
  ).state("tab.today",
    url: "/info/today"
    views:
      "tab-home":
        templateUrl: "tabs/info/tab-today.html"
        controller: "TalkController"
  ).state("resort",
    url: "/resort"
    templateUrl: "resort/resort.html"
    controller: "ResortController"
    resolve:
      resort: (resortsDA, user) ->
        user.getHomeAsync().then (home) ->          
          resortsDA.getInfo(home.code)        
  ).state("resort.main",
    url: "/main"
    views:
      "resort-main":
        templateUrl: "resort/resort-main.html"
  ).state("resort.contacts",
    url: "/contacts"
    views:
      "resort-contacts":
        templateUrl: "resort/resort-contacts.html"
  ).state("resort.maps",
    url: "/maps"
    views:
      "resort-maps":
        templateUrl: "resort/resort-maps.html"
  ).state("resort.prices",
    url: "/prices"
    views:
      "resort-prices":
        templateUrl: "resort/resort-prices.html"
  ).state("faq",
    url: "/faq"
    templateUrl: "faq/faq.html"
    abstract: true
    resolve:
      home: (user) ->
        user.getHomeAsync()    
  ).state("faq.item",
    url: "/list/:id"
    resolve:
      thread: (boardDA, $stateParams) ->
        boardDA.getThread($stateParams.id)    
    views:
      "faq-content":
        templateUrl: "faq/faq-item.html"    
        controller: "FaqItemController"
  ).state("faq.list",
    url: "/list"
    views:
      "faq-content":
        templateUrl: "faq/faq-list.html"    
        controller: "FaqListController"
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
  $httpProvider.interceptors.push "httpFailureInterceptor"

app.config ($sceDelegateProvider) ->
  $sceDelegateProvider.resourceUrlWhitelist ["self", "http://ipeye.ru/ipeye_service/api/**"]

app.config ($ionicConfigProvider) ->
  #$ionicConfigProvider.views.maxCache(5);
  $ionicConfigProvider.backButton.text("")