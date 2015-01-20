app = angular.module("ride-better", [
  "ionic", "angular-data.DSCacheFactory", "angular-authio-jwt", "angularMoment", "angularFileUpload"
]).run(($ionicPlatform, $rootScope, user, cacheManager) ->

  $ionicPlatform.ready ->
    StatusBar.styleDefault() if window.StatusBar
    user.activate()
)
.config ($stateProvider) ->
  _resortResolved = {}
  _stateResolved = {}
  _homeResolved = {}
  $stateProvider.state("root",
    url : "/:culture/:id"
    abstract: true
    controller: "RootController"
    template: "<ion-nav-view name='root'></ion-nav-view>"
    resolve:
      stateResolved: ($stateParams, spotsDA, $q) ->  
        spotsDA.get($stateParams.id).then (res) ->
          culture = $stateParams.culture.split("-")
          res = 
            spot : res
            culture : 
              code : $stateParams.culture
              lang : culture[0]
              units : culture[1]
          angular.copy res, _stateResolved    
          console.log "app.coffee:29 >>>", _stateResolved 
          _stateResolved
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
        homeDA.get(spot : $stateParams.id, lang : culture[0], culture : culture[1]).then (res) ->
          angular.copy res, _homeResolved
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
  ).state("root.main.messages-item",
    url: "/messages/:threadId"
    abstract : true
    views:
      "main-messages": 
        template: "<ion-nav-view name='main-messages-item' style='background-color: white'></ion-nav-view>"
        controller: "MessageController"
    resolve:
      thread: (boardDA, $stateParams, $q) ->
        boardDA.getThread($stateParams.threadId).then null, ->
          console.log "Message not found"
          $q.when()                  
  ).state("root.main.messages-item.content",
    url: "/content"
    views:
      "main-messages-item":
        templateUrl: "main/message.html"        
  ).state("root.main.messages-item.replies",
    url: "/replies"
    views:
      "main-messages-item":
        templateUrl: "messages/messgae-replies.html"
  ).state("root.main.messages-item.requests",
    url: "/requests"
    views:
      "main-messages-item":
        templateUrl: "messages/transfer-requests.html"
  ).state("root.main.messages",
    url: "/messages"
    views:
      "main-messages":
        templateUrl: "main/messages.html"
        controller: "MessagesController"
    resolve:
      userResolved: (user) ->  
        user.getUserAsync()
  ).state("root.main.hist",
    url: "/hist"
    views:
      "main-hist":
        templateUrl: "main/snow-hist.html"
        controller: "SnowHistController"
    resolve:
      userResolved: (user) ->  
        user.getUserAsync()        
  ).state("root.main.forecast",
    url: "/forecast"
    views:
      "main-forecast":
        templateUrl: "main/forecast.html"
        controller: "ForecastController"
  ).state("root.main.favs",
    url: "/favs"
    views:
      "main-favs":
        templateUrl: "user/favs.html"
        controller: "FavsController"
    resolve:
      userResolved: (user) ->
        user.getUserAsync()        
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
  ###
  .state("root.messages-item-replies",
    url: "/messages/:threadId/replies"
    templateUrl: "messages/messgae-replies.html"
    controller: "RepliesController"
    resolve:
      thread: (boardDA, $stateParams, $q) ->
        boardDA.getThread($stateParams.threadId).then null, ->
          console.log "Message not found"
          $q.when()                          
  )
  ###

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

