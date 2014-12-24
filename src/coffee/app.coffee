app = angular.module("ride-better", [
  "ionic", "angular-data.DSCacheFactory", "angular-authio-jwt", "angularMoment", 'googlechart'
]).run(($ionicPlatform, $rootScope, user) ->

  $ionicPlatform.ready ->
    StatusBar.styleDefault() if window.StatusBar
    user.activate().then ->
      $rootScope.activated = true
      $rootScope.$broadcast("app.activated")
)
.config ($stateProvider) ->

  $stateProvider.state("main",
    url: "/:id/main"
    abstract: true
    templateUrl: "main/main.html"
    resolve:
      userResolved: (user) ->
        user.getHomeAsync()
      spotResolved: ($stateParams, $rootScope) ->        
        $rootScope.currentSpot = $stateParams.id
        $stateParams.id
  ).state("main.home",
    url: "/home",
    views:
      "main-home":
        templateUrl: "main/home.html"
        controller: "HomeController"
  ).state("main.report",
    url: "/report"
    views:
      "main-home":
        templateUrl: "main/send-report.html"
        controller: "SendReportController"
  ).state("main.closed",
    url: "/closed"
    views:
      "main-home":
        templateUrl: "main/closed-report.html"
        controller: "ClosedReportController"
  ).state("main.reports",
    url: "/reports"
    views:
      "main-reports":
        templateUrl: "main/reports.html"
        controller: "ReportsController"
  ).state("main.hist",
    url: "/hist"
    views:
      "main-hist":
        templateUrl: "main/snow-hist.html"
        controller: "SnowHistController"
  ).state("main.forecast",
    url: "/forecast"
    views:
      "main-forecast":
        templateUrl: "main/forecast.html"
        controller: "ForecastController"
  ).state("main.webcam",
    url: "/webcam"
    views:
      "main-webcam":
        templateUrl: "main/webcam.html"
        controller: "WebcamController"
  ).state("user",
    url: "/user"
    templateUrl: "user/user.html"
    abstract: true
    resolve:
      home: (resortsDA, user) ->
        user.getHomeAsync().then (home) ->          
          resortsDA.getInfo(home.code)          
  )
  .state("user.favs",
    url: "/favs"
    views:
      "user-favs":
        templateUrl: "user/user-favs.html"
        controller: "FavsController"
  ).state("user.settings",
    url: "/settings"
    views:
      "tab-user":
        templateUrl: "user/user-settings.html"
        controller: "UserController"
  ).state("resort",
    url: "/:id/resort"
    templateUrl: "resort/resort.html"
    controller: "ResortController"
    resolve:
      resortResolved: (resortsDA, $stateParams, $rootScope) ->
        console.log "app.coffee:92 >>>", $stateParams.id
        $rootScope.currentSpot = $stateParams.id
        resortsDA.getInfo($stateParams.id)        
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
    url: "/:id/faq"
    templateUrl: "faq/faq.html"
    abstract: true
    resolve:
      spotResolved: ($stateParams, $rootScope) ->        
        $rootScope.currentSpot = $stateParams.id
        $stateParams.id
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

app.config ($urlRouterProvider) ->
  
  $urlRouterProvider.otherwise ($injector, $location) -> 
    user = $injector.get("user")
    user.getHomeAsync().then (res) ->
      console.log "app.coffee:140 >>>", res
      href = "#{res.code}/main/home"    
      $location.path href


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