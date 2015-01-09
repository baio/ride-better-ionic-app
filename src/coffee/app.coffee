app = angular.module("ride-better", [
  "ionic", "angular-data.DSCacheFactory", "angular-authio-jwt", "angularMoment", 'n3-line-chart', "angularFileUpload"
]).run(($ionicPlatform, $rootScope, user) ->

  $ionicPlatform.ready ->
    StatusBar.styleDefault() if window.StatusBar
    user.activate()
)
.config ($stateProvider) ->
  _resortResolved = {}
  $stateProvider.state("root",
    url : "/:culture/:id"
    abstract: true
    controller: "RootController"
    template: "<ion-nav-view name='root'></ion-nav-view>"
    resolve:
      stateResolved: ($stateParams, spotsDA, $q) ->  
        spotsDA.get($stateParams.id).then (res) ->
          culture = $stateParams.culture.split("-")
          spot : res
          culture : 
            code : $stateParams.culture
            lang : culture[0]
            units : culture[1]
        , (err) ->
          console.log "Failure, can't get spot"
          $q.when("Failure, can't get spot")
  ).state("root.add",
    url: "/add"
    views:
      root:
        templateUrl: "add/addStuff.html"
        controller: "AddStuffController"
        resolve:
          userResolved: (user) ->
            user.login()
  ).state("root.main",
    url: "/main"
    abstract: true  
    resolve:
      homeResolved: ($stateParams, homeDA) ->  
        culture = $stateParams.culture.split("-")             
        homeDA.get(spot : $stateParams.id, lang : culture[0], culture : culture[1])
    views:
      root:
        templateUrl: "main/main.html"
        controller: "MainController"
  ).state("root.main.home",
    url: "/home",
    views:
      "main-home":
        templateUrl: "main/home.html"
        controller: "HomeController"
  ).state("root.main.report",
    url: "/report"
    views:
      "main-home":
        templateUrl: "main/send-report.html"
        controller: "SendReportController"
        resolve:
          userResolved: (user) ->  
            user.login()
  ).state("root.main.closed",
    url: "/closed"
    views:
      "main-home":
        templateUrl: "main/closed-report.html"
        controller: "ClosedReportController"
  ).state("root.main.messages",
    url: "/messages"
    views:
      "main-messages":
        templateUrl: "main/messages.html"
        controller: "MessagesController"
  ).state("root.main.hist",
    url: "/hist"
    views:
      "main-hist":
        templateUrl: "main/snow-hist.html"
        controller: "SnowHistController"
  ).state("root.main.forecast",
    url: "/forecast"
    views:
      "main-forecast":
        templateUrl: "main/forecast.html"
        controller: "ForecastController"
  ).state("root.resort",
    url: "/resort"
    abstract: true
    views:
      root:
        templateUrl: "resort/resort.html"          
        controller: "ResortController"
    resolve:      
      resortResolved: (resortsDA, $stateParams) ->
        resortsDA.getInfo($stateParams.id).then (res) ->
          angular.copy res, _resortResolved
          _resortResolved
  ).state("root.resort.main",
    url: "/main"
    views:
      "resort-main":
        templateUrl: "resort/resort-main.html"
  ).state("root.resort.contacts",
    url: "/contacts"
    views:
      "resort-contacts":
        templateUrl: "resort/resort-contacts.html"
  ).state("root.resort.maps",
    url: "/maps"
    views:
      "resort-maps":
        templateUrl: "resort/resort-maps.html"
  ).state("root.resort.webcams",
    url: "/webcams"
    views:
      "resort-webcams":
        templateUrl: "resort/resort-webcams.html"
        controller: "WebcamController"
  ).state("root.msg",
    url: "/msg"
    abstract: true
    views:
      root:
        templateUrl: "messages/messages.html"          
  ).state("root.msg.messages-item",
    url: "/messages/:threadId"
    resolve:
      thread: (boardDA, $stateParams, $q) ->
        boardDA.getThread($stateParams.threadId).then null, ->
          console.log "Message not found"
          $q.when()          
    views:
      "msg-messages":
        templateUrl: "messages/messages-item.html"    
        controller: "MessagesItemController"
  ).state("root.msg.messages",
    url: "/messages"
    views:
      "msg-messages":
        templateUrl: "messages/messages-list.html"    
        controller: "MessagesListController"
  ).state("root.msg.reports-item",
    url: "/reports/:threadId"
    resolve:
      thread: (boardDA, $stateParams, $q) ->
        boardDA.getThread($stateParams.threadId).then null, ->
          console.log "Message not found"
          $q.when()          
    views:
      "msg-reports":
        templateUrl: "messages/reports-item.html"    
        controller: "ReportsItemController"
  ).state("root.msg.reports",
    url: "/reports"
    views:
      "msg-reports":
        templateUrl: "messages/reports-list.html"    
        controller: "ReportsListController"
  ).state("root.msg.faq-item",
    url: "/faq/:threadId"
    resolve:
      thread: (boardDA, $stateParams, $q) ->
        boardDA.getThread($stateParams.threadId).then null, ->
          console.log "Message not found"
          $q.when()              
    views:
      "msg-faq":
        templateUrl: "messages/faq-item.html"    
        controller: "FaqItemController"
  ).state("root.msg.faq",
    url: "/faq"
    views:
      "msg-faq":
        templateUrl: "messages/faq-list.html"    
        controller: "FaqListController"
  ).state("root.msg.transfer-item",
    url: "/transfer/:threadId"
    resolve:
      thread: (boardDA, $stateParams, $q) ->
        boardDA.getThread($stateParams.threadId).then null, ->
          console.log "Message not found"
          $q.when()              
    views:
      "msg-transfer":
        templateUrl: "messages/transfer-item.html"    
        controller: "TransferItemController"
  ).state("root.msg.transfer",
    url: "/transfer"
    views:
      "msg-transfer":
        templateUrl: "messages/transfer-list.html"    
        controller: "TransferListController"
  ).state("root.prices",
    url: "/prices"
    abstract: true
    views:
      root:
        templateUrl: "prices/prices.html"             
    resolve:
      pricesResolved: (pricesDA, stateResolved) ->
        pricesDA.get(stateResolved.spot.id)            
  ).state("root.prices.lifts",
    url: "/lifts"
    views:
      "prices-lifts":
        templateUrl: "prices/prices-content.html"    
        controller: "PricesController"     
        resolve: 
          pricesViewResolved: (pricesResolved) ->
            console.log "app.coffee:146 >>>", pricesResolved 
            pricesResolved.prices.filter (f) -> f.tag == "lift"
  ).state("root.prices.rent",
    url: "/rent"
    views:
      "prices-rent":
        templateUrl: "prices/prices-content.html"    
        controller: "PricesController"     
    resolve:
      pricesViewResolved: (pricesResolved) ->
        pricesResolved.prices.filter (f) -> f.tag == "rent"
  ).state("root.prices.food",
    url: "/food"
    views:
      "prices-food":
        templateUrl: "prices/prices-content.html"    
        controller: "PricesController"     
    resolve:
      pricesViewResolved: (pricesResolved) ->
        pricesResolved.prices.filter (f) -> f.tag == "food"
  ).state("root.prices.services",
    url: "/services"
    views:
      "prices-services":
        templateUrl: "prices/prices-content.html"    
        controller: "PricesController"     
    resolve:
      pricesViewResolved: (pricesResolved) ->
        pricesResolved.prices.filter (f) -> f.tag == "service"
  ).state("user",
    url: "/user"
    abstract: true
    templateUrl: "user/user.html"
    controller: "RootController"
    resolve:
      userResolved: (user) ->
        user.getUserAsync()
      stateResolved: (user) ->  
        user.getUserAsync().then ->
          spot : user.getHome()
          culture : 
            code : user.getLang() + "-" + user.getCulture()
            lang : user.getLang()
            units : user.getCulture()      
  ).state("user.favs",
    url: "/favs"
    views:
      "user-favs":
        templateUrl: "user/favs.html"
        controller: "FavsController"
  ).state("user.settings",
    url: "/settings"
    views:
      "user-settings":
        templateUrl: "user/settings.html"
        controller: "SettingsController"
  )

app.config ($urlRouterProvider) ->  

  $urlRouterProvider.otherwise ($injector, $location) -> 
    user = $injector.get("user")
    user.getUserAsync().then (ur) ->
      home = ur.settings.favs.filter((f) -> f.isHome)[0]
      home ?= ur.settings.favs[0]
      href = "#{ur.settings.lang}-#{ur.settings.culture}/#{home.id}/main/home"    
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
  $ionicConfigProvider.backButton.text("Back")

app.config ($compileProvider)->
  $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|ftp|mailto|file|tel|local|data|content):/)
