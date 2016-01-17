var app;

app = angular.module("ride-better", ["ionic", "angular-data.DSCacheFactory", "angular-authio-jwt", "angularMoment", "angularFileUpload", "baio-ng-cordova"]).run(function($ionicPlatform, $rootScope, user, notifier, resources, $state, pushService) {
  var lang, rm_lang;
  console.log("start");
  $rootScope.$on("$stateChangeError", function(evt) {
    console.log("$stateChangeError", evt);
    evt.preventDefault();
    return $state.go("error");
  });
  lang = user.getLangFromCache();
  if (lang == null) {
    lang = "ru";
  }
  rm_lang = lang === "ru" ? "en" : "ru";
  angular.element(document.getElementById("body_" + rm_lang)).remove();
  return $ionicPlatform.ready(function() {
    if (window.screen && window.screen.lockOrientation) {
      screen.lockOrientation("portrait");
    }
    if (window.StatusBar) {
      StatusBar.styleDefault();
    }
    user.activate();
    pushService.register();
    return void 0;
  });
}).config(function($stateProvider) {
  var _homeResolved, _resortResolved, _stateResolved;
  _resortResolved = {};
  _stateResolved = {};
  _homeResolved = {};
  return $stateProvider.state("root", {
    url: "/:culture/:id",
    abstract: true,
    controller: "RootController",
    template: "<ion-nav-view name='root'></ion-nav-view>",
    resolve: {
      stateResolved: function($stateParams, spotsDA) {
        return spotsDA.get($stateParams.id).then(function(res) {
          var culture;
          culture = $stateParams.culture.split("-");
          res = {
            spot: res,
            culture: {
              code: $stateParams.culture,
              lang: culture[0],
              units: culture[1]
            }
          };
          return angular.extend(_stateResolved, res);
        });
      }
    }
  }).state("root.add", {
    url: "/add",
    views: {
      root: {
        templateUrl: "add/addStuff.html",
        controller: "AddStuffController",
        resolve: {
          userResolved: function(user) {
            return user.login();
          }
        }
      }
    }
  }).state("root.main", {
    url: "/main",
    abstract: true,
    views: {
      root: {
        templateUrl: "main/main.html",
        controller: "MainController"
      }
    },
    resolve: {
      homeResolved: function($stateParams, homeDA) {
        var culture;
        culture = $stateParams.culture.split("-");
        return homeDA.get({
          spot: $stateParams.id,
          lang: culture[0],
          culture: culture[1]
        }).then(function(res) {
          return angular.extend(_homeResolved, res);
        });
      }
    }
  }).state("root.main.home", {
    url: "/home",
    views: {
      "main-home": {
        templateUrl: "main/home.html",
        controller: "HomeController"
      }
    }
  }).state("root.main.home-reports", {
    url: "/home/reports",
    views: {
      "main-home": {
        templateUrl: "main/home/messages.html",
        controller: "HomeMessagesController"
      }
    },
    resolve: {
      messagesOptsResolved: function(homeResolved) {
        return {
          initialItems: homeResolved.reports,
          board: "report"
        };
      }
    }
  }).state("root.main.home-important", {
    url: "/home/important",
    views: {
      "main-home": {
        templateUrl: "main/home/messages.html",
        controller: "HomeMessagesController"
      }
    },
    resolve: {
      messagesOptsResolved: function(homeResolved) {
        return {
          initialItems: homeResolved.latestImportant,
          board: "message"
        };
      }
    }
  }).state("root.main.report", {
    url: "/report",
    views: {
      "main-home": {
        templateUrl: "main/send-report.html",
        controller: "SendReportController",
        resolve: {
          userResolved: function(user) {
            return user.login();
          }
        }
      }
    }
  }).state("root.main.home-message", {
    url: "/home/messages/:threadId",
    abstract: true,
    views: {
      "main-home": {
        template: "<ion-nav-view name='main-home-message' style='background-color: white'></ion-nav-view>",
        controller: "MessageController"
      }
    },
    resolve: {
      thread: function(boardDA, $stateParams, $q) {
        return boardDA.getThread($stateParams.threadId);
      }
    }
  }).state("root.main.home-message.content", {
    url: "/content",
    views: {
      "main-home-message": {
        templateUrl: "main/message.html"
      }
    }
  }).state("root.main.home-message.replies", {
    url: "/replies",
    views: {
      "main-home-message": {
        templateUrl: "messages/messgae-replies.html"
      }
    }
  }).state("root.main.messages-item", {
    url: "/messages/:threadId",
    abstract: true,
    views: {
      "main-messages": {
        template: "<ion-nav-view name='main-messages-item' style='background-color: white'></ion-nav-view>",
        controller: "MessageController"
      }
    },
    resolve: {
      thread: function(boardDA, $stateParams) {
        return boardDA.getThread($stateParams.threadId);
      }
    }
  }).state("root.main.messages-item.content", {
    url: "/content",
    views: {
      "main-messages-item": {
        templateUrl: "main/message.html"
      }
    }
  }).state("root.main.messages-item.replies", {
    url: "/replies",
    views: {
      "main-messages-item": {
        templateUrl: "messages/messgae-replies.html"
      }
    }
  }).state("root.main.messages-item.requests", {
    url: "/requests",
    views: {
      "main-messages-item": {
        templateUrl: "messages/transfer-requests.html"
      }
    }
  }).state("root.main.messages", {
    url: "/messages",
    views: {
      "main-messages": {
        templateUrl: "main/messages.html",
        controller: "MessagesController"
      }
    },
    resolve: {
      userResolved: function(user) {
        return user.getUserAsync();
      }
    }
  }).state("root.main.hist", {
    url: "/hist",
    views: {
      "main-hist": {
        templateUrl: "main/snow-hist.html",
        controller: "SnowHistController"
      }
    },
    resolve: {
      userResolved: function(user) {
        return user.getUserAsync();
      }
    }
  }).state("root.main.forecast", {
    url: "/forecast",
    views: {
      "main-forecast": {
        templateUrl: "main/forecast.html",
        controller: "ForecastController"
      }
    }
  }).state("root.main.forecast-hourly", {
    url: "/forecast-hourly/:index",
    views: {
      "main-forecast": {
        templateUrl: "main/forecast-hourly.html",
        controller: "ForecastHourlyController"
      }
    },
    resolve: {
      indexResolved: function(boardDA, $stateParams, $q) {
        return $stateParams.index;
      }
    }
  }).state("root.main.favs", {
    url: "/favs",
    views: {
      "main-favs": {
        templateUrl: "user/favs.html",
        controller: "FavsController"
      }
    },
    resolve: {
      userResolved: function(user) {
        return user.getUserAsync();
      }
    }
  }).state("root.resort", {
    url: "/resort",
    abstract: true,
    views: {
      root: {
        templateUrl: "resort/resort.html",
        controller: "ResortController"
      }
    },
    resolve: {
      resortResolved: function(resortsDA, $stateParams) {
        return resortsDA.getInfo($stateParams.id).then(function(res) {
          return angular.extend(_resortResolved, res);
        });
      }
    }
  }).state("root.resort.main", {
    url: "/main",
    views: {
      "resort-main": {
        templateUrl: "resort/resort-main.html"
      }
    }
  }).state("root.resort.contacts", {
    url: "/contacts",
    views: {
      "resort-contacts": {
        templateUrl: "resort/resort-contacts.html"
      }
    }
  }).state("root.resort.maps", {
    url: "/maps",
    views: {
      "resort-maps": {
        templateUrl: "resort/resort-maps.html"
      }
    }
  }).state("root.resort.webcams", {
    url: "/webcams",
    views: {
      "resort-webcams": {
        templateUrl: "resort/resort-webcams.html",
        controller: "WebcamController"
      }
    }
  }).state("root.prices", {
    url: "/prices",
    abstract: true,
    views: {
      root: {
        templateUrl: "prices/prices.html"
      }
    },
    resolve: {
      pricesResolved: function(pricesDA, stateResolved) {
        return pricesDA.get(stateResolved.spot.id);
      }
    }
  }).state("root.prices.lifts", {
    url: "/lifts",
    views: {
      "prices-lifts": {
        templateUrl: "prices/prices-content.html",
        controller: "PricesController",
        resolve: {
          pricesViewResolved: function(pricesResolved) {
            return pricesResolved.prices.filter(function(f) {
              return f.tag === "lift";
            });
          }
        }
      }
    }
  }).state("root.prices.rent", {
    url: "/rent",
    views: {
      "prices-rent": {
        templateUrl: "prices/prices-content.html",
        controller: "PricesController"
      }
    },
    resolve: {
      pricesViewResolved: function(pricesResolved) {
        return pricesResolved.prices.filter(function(f) {
          return f.tag === "rent";
        });
      }
    }
  }).state("root.prices.food", {
    url: "/food",
    views: {
      "prices-food": {
        templateUrl: "prices/prices-content.html",
        controller: "PricesController"
      }
    },
    resolve: {
      pricesViewResolved: function(pricesResolved) {
        return pricesResolved.prices.filter(function(f) {
          return f.tag === "food";
        });
      }
    }
  }).state("root.prices.services", {
    url: "/services",
    views: {
      "prices-services": {
        templateUrl: "prices/prices-content.html",
        controller: "PricesController"
      }
    },
    resolve: {
      pricesViewResolved: function(pricesResolved) {
        return pricesResolved.prices.filter(function(f) {
          return f.tag === "service";
        });
      }
    }
  }).state("user", {
    url: "/user",
    abstract: true,
    templateUrl: "user/user.html",
    controller: "RootController",
    resolve: {
      userResolved: function(user) {
        return user.getUserAsync();
      },
      stateResolved: function(user) {
        return user.getUserAsync().then(function() {
          return {
            spot: user.getHome(),
            culture: {
              code: user.getLang() + "-" + user.getCulture(),
              lang: user.getLang(),
              units: user.getCulture()
            }
          };
        });
      }
    }
  }).state("user.favs", {
    url: "/favs",
    views: {
      "user-favs": {
        templateUrl: "user/favs.html",
        controller: "FavsController"
      }
    }
  }).state("user.settings", {
    url: "/settings",
    views: {
      "user-settings": {
        templateUrl: "user/settings.html",
        controller: "SettingsController"
      }
    }
  }).state("error", {
    url: "/error",
    templateUrl: "utils/error.html"
  });
});

app.config(function($urlRouterProvider) {
  return $urlRouterProvider.otherwise(function($injector, $location) {
    var user;
    user = $injector.get("user");
    return user.getUserAsync().then(function(ur) {
      var home, href;
      home = ur.settings.favs.filter(function(f) {
        return f.isHome;
      })[0];
      if (home == null) {
        home = ur.settings.favs[0];
      }
      href = ur.settings.lang + "-" + ur.settings.culture + "/" + home.id + "/main/home";
      return $location.path(href);
    });
  });
});

app.config(function(DSCacheFactoryProvider) {
  return DSCacheFactoryProvider.setCacheDefaults({
    maxAge: 1000 * 60 * 60 * 24 * 100,
    deleteOnExpire: 'aggressive',
    storageMode: 'localStorage'
  });
});

app.config(function(authioLoginProvider, authConfig) {
  return authioLoginProvider.initialize({
    oauthio_key: authConfig.oauthio_key,
    baseUrl: authConfig.apiUrl,
    user: authConfig.user
  });
});

app.constant("angularMomentConfig", {
  preprocess: 'unix'
});

app.config(function($httpProvider) {
  return $httpProvider.interceptors.push("httpFailureInterceptor");
});

app.config(function($sceDelegateProvider) {
  return $sceDelegateProvider.resourceUrlWhitelist(["self", "http://ipeye.ru/ipeye_service/api/**"]);
});

app.config(function($ionicConfigProvider) {
  return $ionicConfigProvider.backButton.text("Back");
});

app.config(function($compileProvider) {
  return $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|ftp|mailto|file|tel|local|data|content):/);
});

"use strict";
app.constant("webApiConfig", {
  url: "//ride-better-web-api.herokuapp.com/"
});

app.constant("pushConfig", {
  keys: {
    android: "730534788406"
  }
});

app.constant("authConfig", {
  oauthio_key: "9E7SoR97JvCrmryqfLMBC5Fe5ic",
  apiUrl: "//auth-server-oauthio.herokuapp.com/"
});

app.controller("RootController", function($rootScope, stateResolved, $state, amMoment, resources) {
  console.log("rootController.coffee:3 >>>");
  $rootScope.open = function(state) {
    return $state.transitionTo("root." + state, {
      id: $rootScope.state.spot.id,
      culture: $rootScope.state.culture.code
    });
  };
  $rootScope.state = stateResolved;
  amMoment.changeLocale(stateResolved.culture.lang);
  return resources.setLang(stateResolved.culture.lang);
});

app.directive("barChart", function() {
  var colors;
  colors = ["#387ef5", "lightblue"];
  return {
    restrict: 'E',
    scope: {
      chartData: "="
    },
    templateUrl: "charts/bar-chart.html",
    controller: function($scope, $element) {
      return $scope.$watch("chartData.items", function(newVal, oldVal) {
        var items, max;
        console.log("bar-chart.coffee:21 >>>");
        if (newVal && JSON.stringify(newVal) !== JSON.stringify(oldVal)) {
          console.log("bar-chart.coffee:23 >>>");
          items = newVal;
          max = Math.max.apply(Math, items.map(function(i) {
            return i.cmt;
          }));
          items = items.map(function(m) {
            var amt, amtp, cmt;
            if (!m.cmt) {
              m.cmt = 0.001;
            }
            cmt = (m.cmt / max) * 100;
            amt = m.amt.map(function(s) {
              return (s / max) * 100;
            });
            amtp = amt.map(function(s) {
              return (s / cmt) * 100;
            });
            return {
              label: m.label,
              cmt: cmt,
              cmtp: 100 - (amt / cmt) * 100,
              amt: amt,
              amtp: amtp
            };
          });
          return $scope.items = items.map(function(m) {
            var bkg, gradients;
            gradients = m.amtp.map(function(s, i) {
              var color1, color2;
              color1 = colors[i];
              color2 = colors[i + 1];
              return ", " + color1 + ", " + color1 + " " + s + "%, " + color2 + " " + s + "%";
            });
            bkg = "-webkit-linear-gradient(left " + gradients + ", lightblue)";
            return {
              label: m.label,
              style: {
                width: m.cmt + "%",
                background: bkg
              }
            };
          });
        }
      });
    }
  };
});

app.directive("collectionRepeatContainerElement", function() {
  return {
    restrict: 'A',
    scope: false,
    link: function(scope, element) {
      console.log("collection-repeat-container-element.coffee:9 >>>");
      return scope.data.containerElement = element;
    }
  };
});

app.directive("openExternal", function() {
  return {
    restrict: 'A',
    scope: {
      openExternal: "@"
    },
    link: function(scope, elem, attrs) {
      return elem.bind('click', function() {
        var html, ref, src, wn;
        if (!scope.openExternal) {
          return;
        }
        src = scope.openExternal;
        if (window.cordova) {
          ref = window.open(src, "_blank”, “location=no,EnableViewPortScale=yes,presentationstyle=pagesheet");
          ref.addEventListener("loadstop", function() {
            return screen.unlockOrientation();
          });
          ref.addEventListener("exit", function() {
            return screen.lockOrientation("portrait");
          });
        } else {
          html = "<head><title>" + attrs.alt + "</title></head><body><img src='" + src + "'></body>";
          wn = window.open();
          wn.document.write(html);
        }
        return true;
      });
    }
  };
});

app.directive("openSystem", function() {
  return {
    restrict: 'A',
    scope: {
      openSystem: "@"
    },
    link: function(scope, elem) {
      return elem.bind('click', function() {
        if (!scope.openSystem) {
          return;
        }
        if (window.cordova) {
          window.open(scope.openSystem, "_system");
        } else {
          window.open(scope.openSystem, "_blank");
        }
        return true;
      });
    }
  };
});

app.directive("threadItem", function($compile, boardThreadType, $timeout) {
  var getTemplate, getThreadType, isThreadOfType, link;
  isThreadOfType = function(thread, type) {
    if (typeof thread === "string") {
      return thread === type;
    } else {
      return thread.tags.indexOf(type) !== -1;
    }
  };
  getThreadType = function(thread) {
    if (isThreadOfType(thread, "faq")) {
      return "faq";
    } else if (isThreadOfType(thread, "message")) {
      return "message";
    } else if (isThreadOfType(thread, "transfer")) {
      return "transfer";
    } else if (isThreadOfType(thread, "report")) {
      return "report";
    }
  };
  getTemplate = function(type) {
    if (type === "report") {
      type = "reports";
    }
    if (type === "message") {
      type = "messages";
    }
    return $templateCache.get("messages/" + type + "-item.html");
  };
  ({
    restrict: 'E',
    scope: true
  });
  return link = function(scope, element, attributes) {
    var template;
    console.log("thread-item.coffee:30 >>>");
    template = boardThreadType.getThreadItemTemplate(scope.board.data.currentThread);
    element.html(template);
    return $compile(element.contents())(scope);

    /*
    TODO : buttons oh header not redrawn here !!! why ?
    scope.$watch "board.data.currentThread", (val) -> 
      console.log "thread-item.coffee:37 >>>", val
      if val
        template = boardThreadType.getThreadItemTemplate(val)
        element.html(template)
        $compile(element.contents())(scope)
     */
  };
});

app.directive("threadListItem", function($compile, boardThreadType) {
  return {
    restrict: 'E',
    scope: true,
    link: function(scope, element, attributes, ctrls) {
      return scope.$watch("thread", function(val) {
        var template;
        console.log("thread-list-item.coffee:13 >>>");
        template = boardThreadType.getThreadTemplate(val);
        element.html(template);
        return $compile(element.contents())(scope);
      });
    }
  };
});

"use strict";
app.filter("capitalize", function() {
  return function(str) {
    if (str) {
      return str[0].toString().toUpperCase() + str.slice(1);
    }
  };
});

"use strict";
app.filter("contact", function($sce) {
  return function(contact) {
    var icon;
    icon = "ion-social-rss-outline";
    switch (contact.type) {
      case "phone":
        icon = "ion-android-call";
        break;
      case "site":
        icon = "ion-earth";
        break;
      case "vk":
        icon = "ion-happy-outline";
        break;
      case "instagram":
        icon = "ion-social-instagram-outline";
        break;
      case "facebook":
        icon = "ion-social-facebook-outline";
        break;
      case "skype":
        icon = "ion-social-skype-outline";
        break;
      case "email":
        icon = "ion-email";
    }
    return "<i class='calm icon " + icon + "'>";
  };
});

"use strict";
app.filter("geo", function($sce) {
  return function(geo) {
    var _geo;
    _geo = angular.copy(geo);
    _geo = _geo.map(function(m) {
      return m.toString().slice(0, 9);
    });
    return $sce.trustAsHtml("<a href='geo:" + (geo.join(",")) + "' class='positive' style='text-decoration: none'><i class='icon ion-ios-location'></i> &nbsp; " + (_geo.join(" ")) + "</a>");
  };
});

"use strict";
app.filter("plus", function() {
  return function(num) {
    if (num > 0) {
      return "+" + num;
    } else {
      return num;
    }
  };
});

"use strict";
app.filter("resourcesStr", function(resources) {
  return function(str) {
    return resources.str(str);
  };
});

"use strict";
app.filter("round", function() {
  return function(num, dec) {
    var m;
    if (num) {
      if (dec) {
        m = Math.pow(10, dec);
        return Math.round(num * m) / m;
      } else {
        return Math.round(num);
      }
    }
  };
});

"use strict";
app.filter("time", function() {
  return function(dateTime) {
    return moment.utc(dateTime, "DD-MM-YYYYTHH:mm").format("HH:mm");
  };
});

var app;

app = angular.module("angular-authio-jwt", ["angular-data.DSCacheFactory"]);

app.factory("authioEndpoints", function($q, $http) {
  var _authBaseUrl;
  _authBaseUrl = null;
  return {
    setUrl: function(url) {
      return _authBaseUrl = url;
    },
    getToken: function() {
      return $http.get(_authBaseUrl + "oauth/token").then(function(res) {
        return res.data;
      });
    },
    signin: function(data) {
      return $http.post(_authBaseUrl + "oauth/signin", data).then(function(res) {
        return res.data;
      });
    },
    user: function(jwt) {
      return $http.get(_authBaseUrl + "oauth/user", {
        headers: {
          authorization: "Bearer " + jwt
        }
      }).then(function(res) {
        return res.data;
      });
    },
    setData: function(jwt, key, data) {
      return $http.put(_authBaseUrl + ("oauth/data/" + key), data, {
        headers: {
          authorization: "Bearer " + jwt
        }
      }).then(function(res) {
        return res.data;
      });
    },
    setPlatform: function(jwt, key, platform) {
      return $http.put(_authBaseUrl + ("oauth/platform/" + key), platform, {
        headers: {
          authorization: "Bearer " + jwt
        }
      }).then(function(res) {
        return res.data;
      });
    }
  };
});

app.provider("authioLogin", function() {
  var _authBaseUrl, _key, _token, _user;
  _user = null;
  _key = null;
  _authBaseUrl = null;
  _token = null;
  return {
    initialize: function(opts) {
      _authBaseUrl = opts.baseUrl;
      _user = opts.user;
      return _key = opts.oauthio_key;
    },
    $get: function($q, authioEndpoints) {
      var activate, popup;
      activate = function() {
        if (_authBaseUrl && _key) {
          authioEndpoints.setUrl(_authBaseUrl);
          OAuth.initialize(_key);
          return _key = null;
        }
      };
      popup = function(provider, opts) {
        var _opts, deferred;
        deferred = $q.defer();
        if (_token) {
          _opts = opts ? angular.copy(opts) : {};
          _opts.state = _token;
          OAuth.popup(provider, _opts).then(function(res) {
            var token;
            token = _token;
            _token = null;
            return deferred.resolve({
              code: res.code,
              token: token,
              provider: provider,
              platform: opts.platform
            });
          }, deferred.reject);
        } else {
          deferred.reject(new Error("Token not found, invoke requestToken first"));
        }
        return deferred.promise;
      };
      return {
        login: function(provider, opts) {
          if (_user) {
            return $q.when(_user);
          }
          activate();
          return popup(provider, opts).then(authioEndpoints.signin);
        },
        requestToken: function() {
          if (_authBaseUrl) {
            activate();
            return authioEndpoints.getToken().then(function(res) {
              return _token = res.token;
            });
          } else {
            return $q.reject(new Error("authBaseUrl not defined"));
          }
        },
        logout: function(provider) {
          activate();
          return OAuth.clearCache(provider);
        },
        getUser: function(jwt) {
          activate();
          return authioEndpoints.user(jwt);
        },
        setData: function(jwt, key, data) {
          activate();
          return authioEndpoints.setData(jwt, key, data);
        },
        setPlatform: function(jwt, key, data) {
          activate();
          return authioEndpoints.setPlatform(jwt, key, data);
        }
      };
    }
  };
});

app.factory("authio", function($q, DSCacheFactory, authioLogin, $rootScope) {
  var cache, getJWT, login, setJWT;
  cache = DSCacheFactory("authioCache");
  getJWT = function() {
    return cache.get("_jwt");
  };
  setJWT = function(jwt) {
    if (jwt) {
      return cache.put("_jwt", jwt);
    } else {
      return cache.remove("_jwt", jwt);
    }
  };
  login = function(provider, opts) {
    var jwt;
    jwt = getJWT();
    if (!jwt && opts.force) {
      return authioLogin.login(provider, opts).then(function(res) {
        setJWT(res.token);
        $rootScope.$broadcast("authio::login", res.profile);
        return res;
      });
    } else if (jwt) {
      return authioLogin.getUser(jwt)["catch"](function(e) {
        setJWT(void 0);
        return $q.reject(e);
      });
    } else {
      return $q.reject(new Error("Token not found"));
    }
  };
  return {
    setData: function(key, data) {
      var jwt;
      jwt = getJWT();
      if (jwt) {
        return authioLogin.setData(jwt, key, data);
      } else {
        return $q.reject(new Error({
          status: 401
        }));
      }
    },
    setPlatform: function(key, platform) {
      var jwt;
      jwt = getJWT();
      if (jwt) {
        return authioLogin.setPlatform(jwt, key, platform);
      } else {
        return $q.reject(new Error({
          status: 401
        }));
      }
    },
    preLogin: function() {
      return authioLogin.requestToken();
    },
    login: login,
    logout: function() {
      return setJWT(void 0);
    },
    getJWT: getJWT,
    isLogined: function() {
      return getJWT();
    }
  };
});

app.factory("cache", function(DSCacheFactory) {
  var _disbale_cachce, _ver, cache;
  cache = DSCacheFactory("app-cache");
  _ver = "2";
  _disbale_cachce = false;
  return {
    get: function(name) {
      var currTime, expired, val;
      if (_disbale_cachce) {
        return;
      }
      val = cache.get(name);
      if (val && val._val) {
        if (val._ver !== _ver) {
          cache.remove(name);
          val._val = void 0;
        } else if (val._expired) {
          expired = val._expired;
          currTime = (new Date()).getTime();
          if (expired <= currTime) {
            cache.remove(name);
            val._val = void 0;
          }
        }
        val = val._val;
      }
      return val;
    },
    put: function(name, val, expired) {
      var exp;
      if (_disbale_cachce) {
        return;
      }
      if (expired) {
        if (expired === "eod" || !isNaN(expired)) {
          if (expired === "eod") {
            exp = moment().endOf("day");
          } else {
            exp = moment().add(expired, "minutes");
          }
          return cache.put(name, {
            _val: val,
            _expired: exp.valueOf(),
            _ver: _ver
          });
        } else {
          throw new Error("Not implemented");
        }
      } else {
        return cache.put(name, {
          _val: val,
          _ver: _ver
        });
      }
    },
    clean: function() {
      if (_disbale_cachce) {
        return;
      }
      return cache.removeAll();
    },
    rm: function(name) {
      if (_disbale_cachce) {
        return;
      }
      return cache.remove(name);
    }
  };
});

app.factory("cultureFormatter", function() {
  var data;
  data = {
    eu: ["km", "cm", "c"],
    uk: ["mi", "in", "c"],
    us: ["mi", "in", "f"]
  };
  return {
    getKnownCulture: function(c) {
      if (data[c]) {
        return c;
      } else {
        return "eu";
      }
    },
    height: function(cm, cre) {
      if (data[cre][1] !== "cm") {
        return Math.round(cm / 0.393701);
      } else {
        return cm;
      }
    },
    heightU: function(cre) {
      return data[cre][1];
    },
    temp: function(c, cre) {
      if (data[cre][2] !== "c") {
        return Math.round(c * 1.8 + 32);
      } else {
        return c;
      }
    },
    tempU: function(cre) {
      console.log("cultureFormatter.coffee:30 >>>", cre);
      if (data[cre][2] === "c") {
        return "C";
      } else {
        return "F";
      }
    },
    dist: function(km, cre) {
      if (data[cre][0] !== "km") {
        return Math.round(km * 0.621371);
      } else {
        return km;
      }
    },
    distU: function(cre) {
      return data[cre][0];
    }
  };
});

app.factory("fileUploadService", function($q, cordovaFileTransfer, $upload) {
  return {
    upload: function(url, file, data, headers, method) {
      if (method == null) {
        method = "post";
      }
      if (window.cordova) {
        return cordovaFileTransfer.upload(url, file, data, headers);
      } else {
        return $upload.upload({
          url: url,
          method: method,
          file: file,
          data: data,
          headers: headers
        });
      }
    }
  };
});

app.factory("geoLocator", function($q) {
  return {
    getPosition: function() {
      var deferred, geolocationError, geolocationOptions, geolocationSuccess;
      deferred = $q.defer();
      geolocationSuccess = function(position) {
        return deferred.resolve({
          lat: position.coords.latitude,
          lon: position.coords.longitude
        });
      };
      geolocationError = function(err) {
        return console.log(">>>geo.coffee:11", err);
      };
      geolocationOptions = {
        enableHighAccuracy: true,
        timeout: 1000 * 60 * 60,
        maximumAge: 1000 * 60 * 15
      };
      navigator.geolocation.getCurrentPosition(geolocationSuccess, geolocationError, geolocationOptions);
      return deferred.promise;
    }
  };
});

app.factory("globalization", function($q, resources, cultureFormatter) {
  return {
    getLangAndCulture: function() {
      var _default, deferred;
      _default = {
        lang: "en",
        culture: "eu"
      };
      deferred = $q.defer();
      if (navigator.globalization) {
        navigator.globalization.getLocaleName(function(locale) {
          var cl, lang, spts;
          spts = locale.value.split("-");
          lang = spts[0].toLowerCase();
          cl = spts.length > 1 ? spts[1].toLowerCase() : lang;
          return deferred.resolve({
            lang: resources.getKnownLang(lang),
            culture: cultureFormatter.getKnownCulture(cl)
          });
        }, function() {
          return deferred.resolve(_default);
        });
      } else {
        deferred.resolve(_default);
      }
      return deferred.promise;
    }
  };
});

app.factory("httpFailureInterceptor", function($injector) {
  return function(promise) {
    promise.then(null, function(err, code) {
      var notifier;
      if (err) {
        if (err.status !== 404) {
          notifier = $injector.get("notifier");
          return notifier.error("Some error occurred, please try again later.");
        }
      }
    });
    return promise;
  };
});

app.factory("imageService", function($q, cordovaCamera) {
  var readAsDataUrl;
  readAsDataUrl = function(file) {
    var deferred, fileReader;
    deferred = $q.defer();
    fileReader = new FileReader();
    fileReader.onloadend = function(evt) {
      return deferred.resolve(evt.target.result);
    };
    fileReader.onerror = function(err) {
      return deferred.reject(err);
    };
    fileReader.readAsDataURL(file);
    return deferred.promise;
  };
  return {
    takePicture: function(isFromGallery) {
      console.log("Alert: takePicture intended to be used in cordova apps");
      return cordovaCamera.takePicture(isFromGallery);
    },
    getPictureFile: function(isFromGallery) {
      console.log("Alert: getPictureFile intended to be used in cordova apps");
      return cordovaCamera.getPictureFile(isFromGallery).then(function(res) {
        return readAsDataUrl(res.url).then(function(dataUrl) {
          return {
            url: res.url,
            file: res.file,
            dataUrl: dataUrl
          };
        });
      });
    },
    getPictureFromFile: function(file) {
      return readAsDataUrl(file).then(function(dataUrl) {
        return {
          file: file,
          dataUrl: dataUrl
        };
      });
    }
  };
});

app.factory("mapper", function() {
  return {
    mapUser: function(user) {
      var ref, res;
      res = {
        profile: user.profile
      };
      if ((ref = user.data) != null ? ref.ride_better : void 0) {
        res.settings = user.data.ride_better;
      }
      return res;
    }
  };
});

app.factory("mobileDetect", function() {
  var md;
  md = new MobileDetect(window.navigator.userAgent);
  return {
    isMobile: function() {
      console.log("mobileDetect.coffee:6 >>>", md.mobile());
      return md.mobile() || window.cordova;
    },
    mobileOS: function() {
      var os;
      if (window.cordova) {
        return;
      }
      os = md.os();
      if (os) {
        os = os.toLowerCase();
        if (os.indexOf("ios") !== -1) {
          return "ios";
        } else if (os.indexOf("android") !== -1) {
          return "android";
        } else if (os.indexOf("windows") !== -1) {
          return "wp";
        }
      }
    }
  };
});

app.factory("notifier", function($ionicPopup, resources, $ionicLoading) {
  return {
    message: function(msg) {
      var ref;
      if ((ref = window.plugins) != null ? ref.toast : void 0) {
        return window.plugins.toast.showLongTop(resources.str(msg));
      } else {
        return $ionicPopup.alert({
          title: resources.str("alert"),
          template: resources.str(msg)
        });
      }
    },
    error: function(msg) {
      var ref;
      if ((ref = window.plugins) != null ? ref.toast : void 0) {
        return window.plugins.toast.showLongTop(msg);
      } else {
        return $ionicPopup.alert({
          title: resources.str("error"),
          template: resources.str(msg)
        });
      }
    },
    showLoading: function() {
      return $ionicLoading.show({
        templateUrl: "utils/loading.html",
        noBackdrop: false
      });
    },
    hideLoading: function() {
      return $ionicLoading.hide();
    },
    notifyNative: function(os) {
      return $ionicPopup.confirm({
        title: resources.str("alert"),
        template: resources.str("install_native_q"),
        okText: resources.str("sure"),
        cancelText: resources.str("not_now")
      });
    },
    confirm: function(template, okText, cancelText) {
      if (okText == null) {
        okText = "yes";
      }
      if (cancelText == null) {
        cancelText = "no";
      }
      return $ionicPopup.confirm({
        title: resources.str("alert"),
        template: resources.str(template),
        okText: resources.str(okText),
        cancelText: resources.str(cancelText)
      });
    }
  };
});

app.factory("pushService", function($rootScope, cordovaPushNotifications, pushConfig, platformsEP, $ionicPopup, user, resources) {
  var showAlert;
  showAlert = function(msg) {
    return $ionicPopup.alert({
      title: resources.str("alert"),
      content: msg
    });
  };
  return {
    register: function() {
      $rootScope.$on("device::push::registered", function(evt, platform) {
        console.log("device::push::registered", platform);
        return user.registerPlatform(platform);
      });
      $rootScope.$on("device::push::error", function(evt, err) {
        return console.log("device::push::error", err);
      });
      $rootScope.$on("device::push::message", function(evt, msg) {
        console.log("device::push::message", msg);
        return showAlert(msg);
      });
      return cordovaPushNotifications.register(pushConfig.keys);
    }
  };
});

app.factory("user", function($q, cache, $rootScope, $ionicModal, resources, geoLocator, authio, mapper, amMoment, globalization, notifier, spotsDA, mobileDetect) {
  var _platform, activate, addSpot, authForm, defaultUser, deferredAuthForm, getCahchedUser, getDefaultLagAndCulture, getDefaultNearestSpot, getHome, getUserAsync, initialize, isFirstLaunch, mapUser, notifyNative, onHomeChanged, onPropertyChanged, putCulture, putLang, putMsgsFilter, registerPlatform, reset, saveChanges, saveChangesOnline, saveChangesToCache, setCulture, setFisrtLaunchComplete, setHome, setLang, setMsgsFilter, setUser, setUserFromCache, showAuthForm, user;
  user = {};
  authForm = null;
  deferredAuthForm = null;
  _platform = void 0;
  initialize = function() {
    return setUser(defaultUser());
  };
  registerPlatform = function(platform) {
    authio.setPlatform("ride_better", platform);
    return _platform = null;
  };
  $rootScope.$on("authio::login", function() {
    if (_platform) {
      return registerPlatform(_platform);
    }
  });
  setUser = function(u) {
    user.profile = u.profile;
    if (u.settings) {
      user.settings = u.settings;
      putLang(user.settings.lang);
      putCulture(user.settings.culture);
      return putMsgsFilter(user.settings.msgsFilter);
    }
  };
  saveChangesToCache = function() {
    return cache.put("user", user);
  };
  saveChangesOnline = function() {
    if (authio.isLogined()) {
      return authio.setData("ride_better", user.settings);
    }
  };
  saveChanges = function() {
    saveChangesToCache();
    return saveChangesOnline();
  };
  defaultUser = function() {
    return {
      profile: null,
      settings: {
        lang: "en",
        culture: "eu",
        favs: [
          {
            id: "1936",
            title: "Завьялиха",
            isHome: true
          }, {
            id: "28",
            title: "Whistler Blackcomb (Garibaldi Lift Co.)"
          }
        ],
        msgsFilter: {
          spots: "all",
          boards: "message,report,faq,transfer"
        }
      }
    };
  };
  getHome = function() {
    return user.settings.favs.filter(function(f) {
      return f.isHome;
    })[0];
  };
  getUserAsync = function() {
    var deferred;
    deferred = $q.defer();
    if ($rootScope.activated) {
      deferred.resolve(user);
    } else {
      $rootScope.$on("app.activated", function() {
        return deferred.resolve(user);
      });
    }
    return deferred.promise;
  };
  reset = function() {
    authio.logout();
    cache.clean();
    angular.copy(defaultUser(), user);
    putLang(user.settings.lang);
    putCulture(user.settings.culture);
    return saveChanges();
  };
  $ionicModal.fromTemplateUrl('modals/authForm.html', {
    animation: "slide-in-up",
    scope: $rootScope
  }).then(function(form) {
    return authForm = form;
  });
  showAuthForm = function() {
    deferredAuthForm = $q.defer();
    authForm.show();
    notifier.showLoading();
    authio.preLogin()["finally"](function() {
      return notifier.hideLoading();
    });
    return deferredAuthForm.promise;
  };
  $rootScope.$on("modal.hidden", function(modal) {
    if (user.profile) {
      return deferredAuthForm.resolve();
    } else {
      return deferredAuthForm.reject();
    }
  });
  $rootScope.authorizeProvider = function(provider) {
    var opts;
    opts = {
      force: true
    };
    notifier.showLoading();
    return authio.login(provider, opts).then(function(res) {
      setUser(mapUser(res));
      return saveChangesToCache();
    })["finally"](function() {
      $rootScope.hideAuthForm();
      return notifier.hideLoading();
    });
  };
  $rootScope.hideAuthForm = function() {
    return authForm.hide();
  };
  putLang = function(lang) {
    user.settings.lang = lang;
    return resources.setLang(lang);
  };
  putCulture = function(c) {
    return user.settings.culture = c;
  };
  putMsgsFilter = function(filter) {
    return user.settings.msgsFilter = filter;
  };
  onHomeChanged = function(home) {
    return $rootScope.$broadcast("user::homeChanged", home);
  };
  onPropertyChanged = function() {
    return $rootScope.$broadcast("user::propertyChanged", user);
  };
  setHome = function(spot) {
    var fav, i, len, ref1;
    ref1 = user.settings.favs;
    for (i = 0, len = ref1.length; i < len; i++) {
      fav = ref1[i];
      fav.isHome = false;
    }
    spot.isHome = true;
    return onHomeChanged(spot);
  };
  addSpot = function(spot) {
    var fav, favs;
    favs = user.settings.favs;
    fav = favs.filter(function(f) {
      return f.id === spot.id;
    })[0];
    if (!fav) {
      favs.push(spot);
      return true;
    } else {
      return false;
    }
  };
  setLang = function(lang) {
    putLang(lang.code);
    saveChanges();
    return onPropertyChanged();
  };
  setCulture = function(c) {
    putCulture(c.code);
    saveChanges();
    return onPropertyChanged();
  };
  setMsgsFilter = function(filter) {
    putMsgsFilter(filter);
    saveChanges();
    return onPropertyChanged();
  };
  getDefaultNearestSpot = function() {
    return geoLocator.getPosition().then(function(geo) {
      return spotsDA.nearest(geo.lat + "," + geo.lon);
    }).then(function(res) {
      var i, len, spot, spots;
      spots = res.map(function(m) {
        return {
          id: m.code,
          title: m.label
        };
      });
      for (i = 0, len = spots.length; i < len; i++) {
        spot = spots[i];
        addSpot(spot);
      }
      return res;
    });
  };
  getDefaultLagAndCulture = function() {
    return globalization.getLangAndCulture().then((function(_this) {
      return function(r) {
        putLang(r.lang);
        putCulture(r.culture);
        return null;
      };
    })(this));
  };
  setFisrtLaunchComplete = function() {
    return cache.put("firstLaunchComplete", true);
  };
  isFirstLaunch = function() {
    return !(cache.get("firstLaunchComplete") === true);
  };
  mapUser = function(user) {
    var ref1, res;
    res = {
      profile: user.profile
    };
    if ((ref1 = user.data) != null ? ref1.ride_better : void 0) {
      res.settings = user.data.ride_better;
    }
    return res;
  };
  getCahchedUser = function() {
    return cache.get("user");
  };
  setUserFromCache = function() {
    var cachedUser;
    cachedUser = getCahchedUser();
    if (cachedUser) {
      setUser(cachedUser);
    }
    return notifier.message("user_not_logined");
  };
  activate = function() {
    var cachedUser, promise;
    notifier.showLoading();
    initialize();
    if (isFirstLaunch()) {
      console.log(">>>user.coffee:146", "This is first launch");
      setFisrtLaunchComplete();
      promise = $q.all([getDefaultNearestSpot(), getDefaultLagAndCulture()]).then(function() {
        if (user.settings.lang === "en") {
          user.settings.favs[0].isHome = false;
          user.settings.favs[1].isHome = true;
        }
        return saveChangesToCache();
      });
    } else {
      if (!authio.isLogined() && user.profile) {
        console.log(">>>user.coffee:153", "Something wrong, user not logined but profile exists! reset profile");
        user.profile = null;
      }
      cachedUser = getCahchedUser();
      if (!cachedUser) {
        console.log(">>>user.coffee:16 3", "This is not first entance, but user doesn't exist in cache");
        promise = $q.when();
      } else {
        if (authio.isLogined() && !cachedUser.profile) {
          console.log(">>>user.coffee:16 3", "Something wrong, user is logined but profile not exists! logout");
          authio.logout();
        }
        if (cachedUser.profile) {
          promise = authio.login(cachedUser.profile.provider, {
            force: false
          }).then(function(res) {
            setUser(mapUser(res));
            return saveChangesToCache();
          })["catch"](function() {
            if (cachedUser && cachedUser.profile) {
              cachedUser.profile = null;
              saveChangesToCache();
            }
            return setUserFromCache();
          });
        } else {
          setUserFromCache();
          promise = $q.when();
        }
      }
    }
    promise["finally"](function(res) {
      $rootScope.activated = true;
      $rootScope.$broadcast("app.activated");
      return notifier.hideLoading();
    });
    return promise;
  };
  notifyNative = function() {
    var os;
    os = mobileDetect.mobileOS();
    if (os) {
      return notifier.notifyNative(os).then(function(res) {
        var ref;
        if (res) {
          switch (os) {
            case "ios":
              ref = "https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/app/945742403";
              break;
            case "android":
              ref = "https://play.google.com/store/apps/details?id=com.ionicframework.ridebetter";
              break;
            case "wp":
              ref = "http://www.windowsphone.com/s?appid=8e18205b-b849-4d41-922b-b5ad2929dc93";
          }
          window.open(ref, "_blank");
        }
        return res;
      });
    } else {
      return $q.when();
    }
  };
  return {
    activate: function() {
      return notifyNative().then(function() {
        return activate();
      });
    },
    getUserAsync: getUserAsync,
    getHome: getHome,
    setHome: function(spot) {
      setHome(spot);
      return saveChanges();
    },
    addSpot: function(spot) {
      addSpot(spot);
      return saveChanges();
    },
    removeSpot: function(spot) {
      var fav, favs;
      favs = user.settings.favs;
      fav = favs.filter(function(f) {
        return f.id === spot.id;
      })[0];
      if (fav) {
        favs.splice(favs.indexOf(fav), 1);
        if (fav.isHome) {
          favs[0].isHome = true;
          onHomeChanged(favs[0]);
        }
        return saveChanges();
      }
    },
    setLang: setLang,
    setMsgsFilter: setMsgsFilter,
    getLang: function() {
      return user.settings.lang;
    },
    setCulture: setCulture,
    getCulture: function() {
      return user.settings.culture;
    },
    login: function() {
      if (!authio.isLogined()) {
        return showAuthForm();
      } else {
        return $q.when();
      }
    },
    logout: function() {
      authio.logout();
      user.profile = null;
      return saveChanges();
    },
    isLogined: function() {
      return authio.isLogined();
    },
    reset: reset,
    user: user,
    setUser: setUser,
    getKey: function() {
      if (user != null ? user.profile : void 0) {
        return user.profile.provider + "_" + user.profile.id;
      }
    },
    isUser: function(ur) {
      return ur.key === this.getKey();
    },
    getLangFromCache: function() {
      var ref1, ref2;
      return (ref1 = getCahchedUser()) != null ? (ref2 = ref1.settings) != null ? ref2.lang : void 0 : void 0;
    },
    registerPlatform: function(platform) {
      if (this.isLogined()) {
        return registerPlatform(platform);
      } else {
        return _platform = platform;
      }
    }
  };
});

app.controller("AddStuffController", function($scope, stateResolved, imageService, resources, notifier, resortsDA, $state) {
  var getPhoto, resetScope, validate;
  console.log("Add Stuff Controller");
  $scope.tagsList = [
    {
      code: "lift",
      name: resources.str("lift_prices")
    }, {
      code: "rent",
      name: resources.str("rent_prices")
    }, {
      code: "food",
      name: resources.str("food_prices")
    }, {
      code: "service",
      name: resources.str("rent_prices")
    }
  ];
  resetScope = function() {
    return $scope.data = {
      photo: {
        file: null,
        src: null,
        url: null
      },
      title: null,
      tag: $scope.tagsList[0]
    };
  };
  resetScope();
  $scope.$on('$ionicView.enter', resetScope);
  validate = function() {
    if (!$scope.data.photo.url && !$scope.data.photo.file) {
      return "photo_required";
    }
    if (!$scope.data.title) {
      return "title_required";
    }
    if (!$scope.data.tag) {
      return "tag_required";
    }
  };
  getPhoto = function(isFromGallery) {
    notifier.showLoading();
    return imageService.takePicture(isFromGallery).then(function(url) {
      if (url) {
        $scope.data.photo.src = url;
        return $scope.data.photo.url = url;
      }
    })["finally"](function() {
      return notifier.hideLoading();
    });
  };
  $scope.takePhoto = function() {
    return getPhoto(false);
  };
  $scope.selectPhoto = function() {
    return getPhoto(true);
  };
  $scope.cancel = function() {
    return $state.transitionTo("root.main.home", {
      id: stateResolved.spot.id,
      culture: stateResolved.culture.code
    });
  };
  $scope.send = function() {
    var data, err, file;
    err = validate();
    if (err) {
      return notifier.message(err);
    } else {
      file = window.cordova ? $scope.data.photo.url : $scope.data.photo.file;
      data = {
        title: $scope.data.title,
        tag: $scope.data.tag.code
      };
      return resortsDA.postPrice(stateResolved.spot.id, file, data).then(function() {
        resetScope();
        return notifier.message("success");
      }, function(err) {
        return notifier.message("fail");
      });
    }
  };
  return $scope.attachPhoto = function(files) {
    if (files.length) {
      return imageService.getPictureFromFile(files[0]).then(function(pic) {
        $scope.data.photo.file = pic.file;
        return $scope.data.photo.src = pic.dataUrl;
      });
    }
  };
});

app.controller("ClosedReportController", function($scope, reportsDA, $state, resources, notifier, user) {
  console.log("ClosedReportController");
  $scope.reasonsList = [
    {
      code: "closed",
      name: resources.str("Unknown")
    }, {
      code: "day-off",
      name: resources.str("Day off")
    }, {
      code: "off-season",
      name: resources.str("Off season")
    }
  ];
  $scope.data = {
    message: null,
    reason: $scope.reasonsList[0],
    openDate: null
  };
  $scope.sendReport = function() {
    var data, openDate;
    if ($scope.data.openDate) {
      openDate = moment.utc($scope.data.openDate, ["YYYY-MM-DD", "DD.MM.YYYY"]);
    }
    if (openDate && !openDate.isValid()) {
      notifier.error("Date in wrong format");
    }
    data = {
      operate: {
        status: $scope.data.reason.code,
        openDate: openDate ? openDate.unix() : void 0
      },
      comment: $scope.data.message
    };
    return reportsDA.send(user.getHome().code, data).then(function(res) {
      return $state.go("tab.home");
    });
  };
  return $scope.cancelReport = function() {
    return $state.go("tab.home");
  };
});

app.controller("ForecastController", function($scope, homeResolved, stateResolved, $state) {
  console.log("Forecast Controller");
  $scope.forecast = homeResolved.forecast;
  return $scope.openHourly = function(item) {
    var index;
    if (item.hourly) {
      index = $scope.forecast.indexOf(item);
      return $state.transitionTo("root.main.forecast-hourly", {
        id: stateResolved.spot.id,
        culture: stateResolved.culture.code,
        index: index
      });
    }
  };
});

app.controller("ForecastHourlyController", function($scope, homeResolved, indexResolved) {
  console.log("ForecastHourly Controller");
  return $scope.forecast = homeResolved.forecast[indexResolved].hourly;
});

app.controller("HomeController", function($scope, stateResolved, $state) {
  console.log("homeController.coffee:3 >>>");
  $scope.getBackgroundStyle = function(icon) {
    if (!icon) {
      return null;
    }
    if (icon.indexOf("clear") !== -1) {
      return "home-container-sun";
    } else if (icon.indexOf("partly-cloudy") !== -1) {
      return "home-container-light-clouds";
    } else if (icon === "cloudy") {
      return "home-container-clouds";
    } else if (icon === "snow") {
      return "home-container-snow";
    } else {
      return "home-container-light-clouds";
    }
  };
  $scope.openImportant = function() {
    return $state.transitionTo("root.main.home-important", {
      id: stateResolved.spot.id,
      culture: stateResolved.culture.code
    });
  };
  return $scope.openReports = function() {
    return $state.transitionTo("root.main.home-reports", {
      id: stateResolved.spot.id,
      culture: stateResolved.culture.code
    });
  };
});

app.controller("HomeMessagesController", function($scope, $state, board, stateResolved, messages, user, boardThreadHeight, messagesOptsResolved, $q, threadsPoolService) {
  var _board, filter, load, prms;
  console.log("HomeMessagesController");
  filter = function() {
    console.log("importantController.coffee:7 >>>");
    return {
      priority: "important",
      spot: stateResolved.spot.id,
      board: "message"
    };
  };
  load = function() {
    console.log("home:12", messagesOptsResolved.initialItems);
    if (!$scope.board.data.threads.length) {
      return $q.when({
        items: messagesOptsResolved.initialItems,
        index: 0,
        canLoadMoreThreads: true
      });
    }
  };
  prms = {
    spot: stateResolved.spot.id,
    board: messagesOptsResolved.board,
    culture: stateResolved.culture.code,
    filter: filter,
    load: load
  };
  _board = new board.Board(prms, $scope, messages.opts);
  $scope.board = _board;
  $scope.spotTitle = stateResolved.spot.title;
  $scope.msgForm = messages.opts.thread.scope;
  $scope.simpleMsgForm = messages.opts.reply.scope;
  $scope.data = {
    containerElement: null
  };
  _board.loadMoreThreads();
  $scope.getThreadHeight = function(thread) {
    return boardThreadHeight.getHeight(thread, $scope.data.containerElement);
  };
  $scope.$on('$destroy', function() {
    console.log("messageController.coffee:55 >>>");
    return _board.dispose();
  });
  $scope.$on('$ionicView.enter', function() {
    return console.log("enter1", $scope.board.data, threadsPoolService.fifo);
  });
  $scope.openThread = function(thread) {
    prms = {
      id: stateResolved.spot.id,
      culture: stateResolved.culture.code,
      threadId: thread._id
    };
    return $state.transitionTo("root.main.home-message.content", prms);
  };
  return $scope.openReplies = function(thread) {
    prms = {
      threadId: thread._id,
      id: stateResolved.spot.id,
      culture: stateResolved.culture.code
    };
    return $state.go("root.main.home-message.replies", prms);
  };
});

app.controller("MainController", function($scope, homeResolved) {
  $scope.culture = homeResolved.culture;
  return $scope.$on("$ionicView.enter", function() {
    $scope.snapshot = homeResolved.snapshot;
    $scope.snowfallHistory = homeResolved.snowfallHistory;
    $scope.reports = homeResolved.reports;
    return $scope.latestImportant = homeResolved.latestImportant;
  });
});

app.controller("MessageController", function($scope, $state, board, thread, stateResolved, baseMessages, $ionicModal, boardThreadHeight) {
  var _board, _requestsModal;
  console.log("MessageItem Controller");
  _board = new board.Board({
    spot: stateResolved.spot.id,
    culture: stateResolved.culture.code
  }, $scope, baseMessages.opts);
  _board.setThread(thread);
  $scope.board = _board;
  $scope.data = {
    containerElement: null
  };
  $scope.msgForm = baseMessages.opts.thread.scope.msgForm;
  $scope.faqMsgForm = baseMessages.opts.thread.scope.faqMsgForm;
  $scope.transferForm = baseMessages.opts.thread.scope.transferForm;
  $scope.reportForm = baseMessages.opts.thread.scope.reportForm;
  $scope.simpleMsgForm = baseMessages.opts.thread.scope.simpleMsgForm;
  _requestsModal = null;
  $ionicModal.fromTemplateUrl("modals/transferRequestsForm.html", {
    scope: $scope,
    animation: 'slide-in-up'
  }).then(function(res) {
    return _requestsModal = res;
  });
  $scope.closeTransferRequests = function(thread) {
    return _requestsModal.hide();
  };
  $scope.$on('$destroy', function() {
    _requestsModal.remove();
    return _board.dispose();
  });
  $scope.openReplies = function(thread) {
    var prms;
    prms = {
      threadId: thread._id,
      id: stateResolved.spot.id,
      culture: stateResolved.culture.code
    };
    return $state.go("^.replies", prms);
  };
  $scope.openTransferRequests = function(thread) {
    var prms;
    prms = {
      threadId: thread._id,
      id: stateResolved.spot.id,
      culture: stateResolved.culture.code
    };
    return $state.go("root.main.messages-item.requests", prms);
  };
  $scope.getReplyHeight = function(reply) {
    return boardThreadHeight.getReplyHeight(reply, $scope.data.containerElement);
  };
  return $scope.removeThread = function(thread) {
    return _board.removeThread(thread).then(function() {
      var prms;
      prms = {
        id: stateResolved.spot.id,
        culture: stateResolved.culture.code
      };
      return $state.go("root.main.messages", prms);
    });
  };
});

app.controller("MessagesController", function($scope, $state, board, stateResolved, baseMessages, $ionicModal, user, userResolved, boardThreadHeight) {
  var _addMsgModal, _board, prms, ref;
  console.log("Messages Controller");
  _addMsgModal = null;
  $ionicModal.fromTemplateUrl("modals/addMsgSelector.html", {
    scope: $scope,
    animation: 'slide-in-up'
  }).then(function(res) {
    return _addMsgModal = res;
  });
  prms = {
    spot: stateResolved.spot.id,
    board: null,
    culture: stateResolved.culture.code
  };
  _board = new board.Board(prms, $scope, baseMessages.opts);
  $scope.board = _board;
  $scope.spotTitle = stateResolved.spot.title;
  $scope.filterMsgsForm = board.filterMsgsFormScope;
  $scope.msgForm = baseMessages.opts.thread.scope.msgForm;
  $scope.faqMsgForm = baseMessages.opts.thread.scope.faqMsgForm;
  $scope.transferForm = baseMessages.opts.thread.scope.transferForm;
  $scope.reportForm = baseMessages.opts.thread.scope.reportForm;
  $scope.simpleMsgForm = baseMessages.opts.thread.scope.simpleMsgForm;
  $scope.data = {
    containerElement: null
  };
  if ((ref = userResolved.settings) != null ? ref.msgsFilter : void 0) {
    _board.restoreFilter(userResolved.settings.msgsFilter);
  }
  $scope.openThread = function(thread) {
    return $state.transitionTo("root.main.messages-item.content", {
      id: stateResolved.spot.id,
      culture: stateResolved.culture.code,
      threadId: thread._id
    });
  };
  $scope.openAddMsgSelector = function() {
    return user.login().then(function() {
      return _addMsgModal.show();
    });
  };
  $scope.cancelAddMsgSelector = function() {
    return _addMsgModal.hide();
  };
  $scope.$on('$destroy', function() {
    _addMsgModal.remove();
    return _board.dispose();
  });
  $scope.createThreadModal = function(thread) {
    if (thread === "report") {
      $state.transitionTo("root.main.report", {
        id: stateResolved.spot.id,
        culture: stateResolved.culture.code
      });
    } else {
      _board.openThreadModal(thread, "create");
    }
    return _addMsgModal.hide();
  };
  _board.loadMoreThreads();
  $scope.getThreadHeight = function(thread) {
    return boardThreadHeight.getHeight(thread, $scope.data.containerElement);
  };
  return $scope.openReplies = function(thread) {
    prms = {
      threadId: thread._id,
      id: stateResolved.spot.id,
      culture: stateResolved.culture.code
    };
    return $state.go("root.main.messages-item.replies", prms);
  };
});

app.controller("SendReportController", function($scope, boardDA, $ionicSlideBoxDelegate, notifier, $q, stateResolved) {
  console.log("SendReport Controller");
  $scope.data = {
    tracks: null,
    snowing: null,
    crowd: null
  };
  $scope.sendReport = function() {
    var data;
    if (!$scope.data.tracks && !$scope.data.snowing && !$scope.data.crowd && !$scope.data.message) {
      notifier.message("data_required");
      return $q.when();
    } else {
      data = {
        meta: {
          conditions: {
            tracks: parseInt($scope.data.tracks),
            snowing: parseInt($scope.data.snowing),
            crowd: parseInt($scope.data.crowd)
          }
        },
        message: $scope.data.message
      };
      return boardDA.postThread({
        spot: stateResolved.spot.id,
        board: "report"
      }, data).then(function(res) {
        return $scope.open("main.home");
      });
    }
  };
  $scope.cancelReport = function() {
    return $scope.open("main.home");
  };
  $scope.nextSlide = function() {
    return $ionicSlideBoxDelegate.next();
  };
  return $scope.closedReport = function() {
    return $scope.open("main.closed");
  };
});

app.controller("SnowHistController", function($scope, resources, stateResolved, cultureFormatter, histDA, userResolved) {
  var getFavName, isChartOfType, loadChart, round, setFavsChart, setSpotChart, units;
  console.log("snowHistController.coffee:3 >>>");
  units = stateResolved.culture.units;
  round = function(val) {
    return Math.round(val * 100) / 100;
  };
  $scope.chartData = {
    items: null
  };
  $scope.chartType = "spot";
  isChartOfType = function(type) {
    return $scope.chartType === type;
  };
  $scope.isChartOfType = isChartOfType;
  $scope.setChartType = function(type) {
    if ($scope.chartType !== type) {
      $scope.chartType = type;
      return loadChart();
    }
  };
  getFavName = function(id) {
    return userResolved.settings.favs.filter(function(f) {
      return f.id === id;
    })[0].title;
  };
  setSpotChart = function(items) {
    var dataItems;
    dataItems = items.map(function(m, i) {
      var amt, cmt;
      cmt = round(m.cumulSnowAmount);
      amt = round(m.type === "snow" ? m.amount : 0);
      return {
        cmt: cmt,
        amt: [amt],
        label: moment.utc(m.date, "X").format("ddd DD MMM") + (" - " + (Math.round(cultureFormatter.height(amt, units))) + " " + (resources.str(cultureFormatter.heightU(units))) + ". -\n" + (Math.round(cultureFormatter.height(cmt, units))) + " " + (resources.str(cultureFormatter.heightU(units))) + ".")
      };
    });
    dataItems.reverse();
    return $scope.chartData.items = dataItems;
  };
  setFavsChart = function(spots) {
    var dataItems, max;
    max = Math.max.apply(Math, spots.map(function(m) {
      return m.items[m.items.length - 1].cumulSnowAmount;
    }));
    dataItems = spots.map(function(m, i) {
      var amt, amt_l, cmt;
      cmt = 100;
      amt = round((m.items[m.items.length - 1].cumulSnowAmount / max) * 100);
      amt_l = round(m.items[m.items.length - 1].cumulSnowAmount);
      return {
        cmt: cmt,
        amt: [amt],
        label: ((Math.round(cultureFormatter.height(amt_l, units))) + " " + (resources.str(cultureFormatter.heightU(units))) + ". ") + getFavName(m.spot)
      };
    });
    dataItems.sort(function(a, b) {
      return a.amt[0] < b.amt[0];
    });
    return $scope.chartData.items = dataItems;
  };
  loadChart = function() {
    var favs;
    favs = userResolved.settings.favs.map(function(m) {
      return m.id;
    }).join("-");
    if (isChartOfType("spot")) {
      return histDA.getSnowfall(stateResolved.spot.id, favs).then(function(res) {
        if (res && res.length) {
          return setSpotChart(res[0].items);
        }
      });
    } else if (isChartOfType("favs")) {
      return histDA.getSnowfall(favs, favs).then(function(res) {
        if (res && res.length) {
          return setFavsChart(res);
        }
      });
    }
  };
  return $scope.$on("$ionicView.enter", function() {
    return loadChart();
  });
});

app.controller("TransferRequestsController", function($scope, thread, stateResolved, boardDA) {
  console.log("transferRequestsController.coffee:3 >>>", thread);
  $scope.thread = thread;
  return $scope.switchAccepted = function(request) {
    var f;
    console.log("transferRequestsController.coffee:8 >>>");
    f = !request.accepted;
    return boardDA.acceptTransferRequest(thread._id, request.user.key, f).then(function() {
      return request.accepted = f;
    });
  };
});

app.controller("PricesController", function($scope, pricesViewResolved, $ionicSlideBoxDelegate, $timeout, $window) {
  console.log("PricesController", pricesViewResolved);
  $scope.prices = pricesViewResolved;
  $scope.$on('$ionicView.enter', function() {
    return $timeout((function() {
      return $ionicSlideBoxDelegate.update();
    }), 0);
  });
  $scope.moveNext = function() {
    return $ionicSlideBoxDelegate.next();
  };
  return $scope.movePrev = function() {
    return $ionicSlideBoxDelegate.previous();
  };
});

app.controller("ResortController", function($scope, $timeout, resortResolved, $ionicSlideBoxDelegate) {
  console.log("resortController.coffee:3 >>>");
  $scope.resort = resortResolved;
  $scope.$on('$ionicView.enter', function() {
    return $timeout((function() {
      return $ionicSlideBoxDelegate.update();
    }), 0);
  });
  $scope.moveNext = function() {
    return $ionicSlideBoxDelegate.next();
  };
  $scope.movePrev = function() {
    return $ionicSlideBoxDelegate.previous();
  };
  return $scope.getContactHref = function(contact) {
    var prefix;
    prefix = null;
    if (contact.type === "phone") {
      prefix = "tel:";
    } else if (contact.type === "email") {
      prefix = "mailto:";
    }
    if (prefix) {
      return prefix + contact.val;
    } else {
      return contact.val;
    }
  };
});

app.controller("WebcamController", function($scope, webcamsDA, notifier) {
  var getIndex, setWebcam;
  console.log("Webcam Controller");
  $scope.current = null;
  $scope.data = {
    currentItem: null
  };
  setWebcam = function(res) {
    var ref;
    console.log(res);
    if ((ref = res.current) != null ? ref.meta : void 0) {
      $scope.current = res.current;
      $scope.list = res.list;
      return $scope.data.currentItem = res.list.filter(function(f) {
        return f.index === res.current.index;
      })[0];
    }
  };
  getIndex = function() {
    if ($scope.data.currentItem) {
      return $scope.data.currentItem.index;
    }
  };
  $scope.loadLatest = function() {
    return webcamsDA.latest({
      spot: "1936",
      index: getIndex()
    }).then(setWebcam);
  };
  $scope.loadPrev = function() {
    console.log("wtf");
    return webcamsDA.prev({
      spot: "1936",
      index: getIndex(),
      time: $scope.current.meta.created
    }).then(setWebcam)["catch"](function() {
      return notifier.message("no_more_images");
    });
  };
  $scope.loadNext = function() {
    return webcamsDA.next({
      spot: "1936",
      index: getIndex(),
      time: $scope.current.meta.created
    }).then(setWebcam)["catch"](function() {
      return notifier.message("no_more_images");
    });
  };
  return $scope.loadLatest();
});

app.controller("FavsController", function($scope, $ionicModal, spotsDA, $state, geoLocator, user, $rootScope) {
  var geo, loadSpots;
  console.log("Favs Controller");
  geo = void 0;
  geoLocator.getPosition().then(function(res) {
    return geo = res.lat + "," + res.lon;
  });
  $scope.favs = user.user.settings.favs;
  loadSpots = function(term) {
    var culture;
    if ((!term && geo) || (term && term.length > 2)) {
      culture = {
        lang: user.user.settings.lang,
        units: user.user.settings.culture
      };
      return spotsDA.find(term, geo, culture).then(function(res) {
        return $scope.spotsList = res;
      });
    } else {
      return $scope.spotsList = null;
    }
  };
  $ionicModal.fromTemplateUrl('modals/spotSelector.html', {
    scope: $scope,
    animation: 'slide-in-up'
  }).then(function(modal) {
    return $scope.spotSelectorModal = modal;
  });
  $scope.openSpotSelectorModal = function() {
    $scope.spotSelectorModal.show();
    if (!$scope.spotsList) {
      return loadSpots(null);
    }
  };
  $scope.closeSpotSelectorModal = function() {
    return $scope.spotSelectorModal.hide();
  };
  $scope.$on('$destroy', function() {
    return $scope.spotSelectorModal.remove();
  });
  $scope.onSpotTermChanged = loadSpots;
  $scope.selectSpot = function(s) {
    var st;
    st = {
      id: s.code,
      title: s.label.replace(/<[^>]+>/gm, '')
    };
    user.addSpot(st);
    return $scope.spotSelectorModal.hide();
  };
  $scope.removeFav = function(s) {
    return user.removeSpot(s);
  };
  $scope.setHome = function(s) {
    user.setHome(s);
    $scope.$root.state.spot = s;
    return $state.go($state.current, {
      id: s.id,
      culture: $rootScope.state.culture.code
    }, {
      reload: true,
      notify: false,
      location: true
    });
  };
  $scope.isHome = user.isHome;
  $scope.canAddFav = function() {
    return $scope.favs && $scope.favs.length < 10;
  };
  $scope.canRemoveFav = function() {
    return $scope.favs && $scope.favs.length > 1;
  };
  $scope.openHome = function(fav) {
    return $state.go("root.main.home", {
      id: fav.id,
      culture: $rootScope.state.culture.code
    }, {
      reload: true,
      notify: true,
      location: true
    });
  };
  return $scope.$on("user::homeChanged", function(obj, home) {
    return $scope.$root.state.spot = home;
  });
});

app.controller("SettingsController", function($scope, user, resources, $window, notifier) {
  var updScopeData;
  console.log("User Controller");
  $scope.login = user.login;
  $scope.logout = user.logout;
  $scope.isLogined = user.isLogined;
  $scope.homeLabel = user.getHome().label;
  $scope.isPropertyChanged = false;
  $scope.reset = function() {
    user.reset();
    return $scope.reload();
  };
  $scope.reload = function() {
    return $window.location.reload(true);
  };
  $scope.culturesList = [
    {
      code: "eu",
      name: resources.str("europe")
    }, {
      code: "uk",
      name: resources.str("united_kingdom")
    }, {
      code: "us",
      name: resources.str("united_states")
    }
  ];
  $scope.langsList = [
    {
      code: "en",
      name: resources.str("english")
    }, {
      code: "ru",
      name: resources.str("russian")
    }
  ];
  $scope.setCulture = user.setCulture;
  $scope.setLang = user.setLang;
  $scope.user = user.user;
  $scope.home = user.getHome();
  $scope.data = {};
  updScopeData = function() {
    $scope.data.culture = $scope.culturesList.filter(function(f) {
      return f.code === user.getCulture();
    })[0];
    return $scope.data.lang = $scope.langsList.filter(function(f) {
      return f.code === user.getLang();
    })[0];
  };
  updScopeData();
  return $scope.$on("user::propertyChanged", function(obj, user) {
    console.log("settingsController.coffee:42 >>>");
    if (user.settings) {
      $scope.isPropertyChanged = true;
      $scope.$root.state.culture = {
        lang: user.settings.lang,
        units: user.settings.culture,
        code: user.settings.lang + "-" + user.settings.culture
      };
      return notifier.message("new_settings_reload");
    }
  });
});

var slice = [].slice;

app.service("board", function($rootScope, boardDA, user, $ionicModal, notifier, filterMsgsFormScope, $q, $ionicScrollDelegate) {
  var Board, _defOpts, createThreadModal;
  _defOpts = {
    board: {
      threadModal: null,
      replyModal: null,
      boardName: null,
      spot: null,
      culture: null,
      filter: null
    },
    thread: {
      modalTemplate: "modals/sendSimpleMsgForm.html",
      map2send: function() {},
      item2scope: function(item) {},
      validate: function() {},
      reset: function() {},
      moveToList: function() {},
      getLoadSpot: null,
      getCreateBoardName: null
    },
    reply: {
      modalTemplate: "modals/sendSimpleMsgForm.html",
      map2send: function() {},
      item2scope: function(item) {},
      validate: function() {},
      reset: function() {}
    }
  };
  createThreadModal = function(template, scope) {
    return $ionicModal.fromTemplateUrl(template, {
      scope: scope,
      animation: 'slide-in-up'
    });
  };
  Board = (function() {
    function Board(prms, scope, opts) {
      this._opts = {};
      this.data = {
        currentThread: null,
        canLoadMoreThreads: false,
        canLoadMoreReplies: false,
        threads: []
      };
      this.init(prms, scope, opts);
    }

    Board.prototype.getFilter = function(spot) {
      var _opts, boards, d, filter, filterBoards, filterSpotsPromise;
      _opts = this._opts;
      if (_opts.board.filter) {
        filter = _opts.board.filter();
        if (filter) {
          return $q.when(filter);
        }
      }
      d = filterMsgsFormScope.scope.data;
      filterSpotsPromise = (function() {
        switch (d.spots) {
          case "current":
            return $q.when(spot);
          case "favs":
            return user.getUserAsync().then(function(ur) {
              return ur.settings.favs.map(function(m) {
                return m.id;
              }).join("-");
            });
          case "all":
            return $q.when("-");
        }
      })();
      boards = [];
      if (d.messages) {
        boards.push("message");
      }
      if (d.faq) {
        boards.push("faq");
      }
      if (d.reports) {
        boards.push("report");
      }
      if (d.transfers) {
        boards.push("transfer");
      }
      filterBoards = boards.length === 4 ? void 0 : boards.join("-");
      return filterSpotsPromise.then(function(filterSpots) {
        return {
          spot: filterSpots,
          board: filterBoards
        };
      });
    };

    Board.prototype.openMsgModal = function(item, mode, type, parent) {
      var _opts;
      _opts = this._opts;
      return user.login().then(function() {
        if (type === "thread") {
          if (_opts.board.threadModalConstruct) {
            return _opts.board.threadModalConstruct(_opts.thread.modalTemplate(item));
          } else {
            return _opts.board.threadModal;
          }
        } else {
          return _opts.board.replyModal;
        }
      }).then(function(msgModal) {
        msgModal.opts = {
          type: type,
          mode: mode,
          item: item,
          parent: parent,
          boardName: _opts.board.boardName
        };
        if (mode === "edit") {
          _opts[type].item2scope(item);
        } else if (mode === "create") {
          if (type === "thread" && _opts.thread.getCreateBoardName) {
            msgModal.opts.boardName = _opts.thread.getCreateBoardName(item);
          }
        }
        return msgModal.show();
      });
    };

    Board.prototype.resetData = function() {
      this.data.currentThread = null;
      this.data.canLoadMoreThreads = false;
      return this.data.canLoadMoreReplies = false;
    };

    Board.prototype.getShownModal = function() {
      var _opts, ref;
      _opts = this._opts;
      if ((ref = _opts.board.threadModal) != null ? ref.isShown() : void 0) {
        return _opts.board.threadModal;
      } else {
        return _opts.board.replyModal;
      }
    };

    Board.prototype.init = function(prms, scope, opts) {
      var _opts;
      $rootScope.$on("thread::remove", (function(_this) {
        return function(evt, thread) {
          var i, j, len, ref, results, th;
          console.log("board.coffee:113 >>>", thread);
          ref = _this.data.threads;
          results = [];
          for (i = j = 0, len = ref.length; j < len; i = ++j) {
            th = ref[i];
            if (th._id === thread._id) {
              console.log("board.coffee:116 >>>", i);
              _this.data.threads.splice(i, 1);
              break;
            } else {
              results.push(void 0);
            }
          }
          return results;
        };
      })(this));
      angular.copy(_defOpts, this._opts);
      _opts = this._opts;
      this.dispose();
      if (opts != null ? opts.thread : void 0) {
        _opts.thread = opts.thread;
      }
      if (opts != null ? opts.reply : void 0) {
        _opts.reply = opts.reply;
      }
      _opts.board.spot = prms.spot;
      _opts.board.boardName = prms.board;
      _opts.board.culture = prms.culture;
      _opts.board.filter = prms.filter;
      _opts.board.load = prms.load;
      this.resetData();
      if (_opts.thread.modalTemplate) {
        if (typeof _opts.thread.modalTemplate === "string") {
          createThreadModal(_opts.thread.modalTemplate, scope).then(function(modal1) {
            return _opts.board.threadModal = modal1;
          });
        } else {
          if (_opts.board.threadModal) {
            _opts.board.threadModal.remove();
          }
          _opts.board.threadModalConstruct = function(template) {
            return createThreadModal(template, scope).then(function(modal1) {
              return _opts.board.threadModal = modal1;
            });
          };
        }
      }
      $ionicModal.fromTemplateUrl(_opts.reply.modalTemplate, {
        scope: scope,
        animation: 'slide-in-up'
      }).then(function(modal2) {
        return _opts.board.replyModal = modal2;
      });
      return $ionicModal.fromTemplateUrl("modals/filterMsgsForm.html", {
        scope: scope,
        animation: 'slide-in-up'
      }).then((function(_this) {
        return function(modal3) {
          return _this._filterModal = modal3;
        };
      })(this));
    };

    Board.prototype.setBoard = function(res, index) {
      var ref;
      this.data.currentThread = null;
      if (index === -1) {
        index = this.data.threads.length;
      }
      (ref = this.data.threads).splice.apply(ref, [index, 0].concat(slice.call(res)));
      return this.data.canLoadMoreThreads = res.length >= 50;
    };

    Board.prototype.loadBoardExternal = function() {
      var _opts, base, loader;
      _opts = this._opts;
      loader = typeof (base = _opts.board).load === "function" ? base.load() : void 0;
      if (loader) {
        _opts.board.load().then((function(_this) {
          return function(res) {
            _this.setBoard(res.items, res.index);
            return _this.data.canLoadMoreThreads = res.canLoadMore;
          };
        })(this));
      }
      return loader;
    };

    Board.prototype.loadBoard = function(opts, pushIndex) {
      var _opts, board, extarnalLoader, spot;
      _opts = this._opts;
      extarnalLoader = this.loadBoardExternal();
      if (extarnalLoader) {
        return extarnalLoader;
      }
      spot = _opts.board.spot;
      board = _opts.board.boardName;
      return this.getFilter(spot).then((function(_this) {
        return function(filter) {
          if (opts == null) {
            opts = {};
          }
          opts.culture = _this._opts.board.culture;
          opts.priority = filter.priority;
          delete filter.priority;
          return boardDA.get(filter, opts);
        };
      })(this)).then((function(_this) {
        return function(res) {
          return _this.setBoard(res, pushIndex);
        };
      })(this))["catch"]((function(_this) {
        return function() {
          return _this.data.canLoadMoreThreads = false;
        };
      })(this));
    };

    Board.prototype.setThread = function(res, index) {
      if (res) {
        this.data.currentThread = res;
      }
      return this.data.canLoadMoreReplies = false;
    };

    Board.prototype.loadThread = function(id, opts, pushIndex) {
      if (opts == null) {
        opts = {};
      }
      opts.culture = this._opts.board.culture;
      return boardDA.getThread(id, opts).then((function(_this) {
        return function(res) {
          return _this.setThread(res, pushIndex);
        };
      })(this))["catch"]((function(_this) {
        return function() {
          return _this.data.canLoadMoreReplies = true;
        };
      })(this));
    };

    Board.prototype.loadMoreThreads = function() {
      var last, since;
      last = this.data.threads[this.data.threads.length - 1];
      if (last) {
        since = moment.utc(last.created, "X").unix();
      }
      return this.loadBoard({
        since: since
      }, -1)["finally"](function() {
        return $rootScope.$broadcast("scroll.infiniteScrollComplete");
      });
    };

    Board.prototype.pullMoreThreads = function() {
      var first, till;
      first = this.data.threads[0];
      if (first) {
        till = moment.utc(first.created, "X").unix();
      }
      return this.loadBoard({
        till: till
      }, 0)["finally"](function() {
        return $rootScope.$broadcast("scroll.refreshComplete");
      });
    };

    Board.prototype.getThread = function(threadId) {
      return this.data.threads.filter(function(f) {
        return f._id === threadId;
      })[0];
    };

    Board.prototype.loadMoreReplies = function(thread) {
      var last, since;
      last = thread.replies[thread.replies.length - 1];
      if (last) {
        since = moment.utc(last.created, "X").unix();
      }
      return this.loadThread(thread._id, {
        since: since
      }).then((function(_this) {
        return function(res) {
          _this.data.canLoadMoreReplies = res.length >= 25;
          return $rootScope.$broadcast("scroll.infiniteScrollComplete");
        };
      })(this))["catch"]((function(_this) {
        return function() {
          return _this.data.canLoadMoreReplies = false;
        };
      })(this));
    };

    Board.prototype.pullMoreReplies = function(thread) {
      var first, till;
      first = thread.replies[0];
      if (first) {
        till = moment.utc(first.created, "X").unix();
      }
      return this.loadThread(thread._id, {
        till: till
      }, 0)["finally"](function() {
        return $rootScope.$broadcast("scroll.refreshComplete");
      });
    };

    Board.prototype.clean = function() {
      this.resetData();
      return this.data.threads = [];
    };

    Board.prototype.removeThread = function(thread) {
      return notifier.confirm("confirm_delete").then(function(res) {
        var home;
        if (res) {
          home = user.getHome().code;
          return boardDA.removeThread(thread);
        }
      }).then((function(_this) {
        return function(res) {
          _this.data.currentThread = null;
          return $rootScope.$broadcast("thread::remove", thread);
        };
      })(this));
    };

    Board.prototype.removeReply = function(thread, reply) {
      return notifier.confirm("confirm_delete").then(function(res) {
        var home;
        if (res) {
          home = user.getHome().code;
          return boardDA.removeReply(reply, thread);
        }
      });
    };

    Board.prototype.dispose = function() {
      var _opts;
      _opts = this._opts;
      if (_opts.board.threadModal) {
        _opts.board.threadModal.remove();
        _opts.board.replyModal.remove();
        _opts.board.threadModal = null;
        _opts.board.replyModal = null;
      }
      if (this._filterModal) {
        this._filterModal.remove();
        return this._filterModal = null;
      }
    };

    Board.prototype.openThreadModal = function(item, mode, modalOpts) {
      return this.openMsgModal(item, mode, "thread");
    };

    Board.prototype.openReplyModal = function(item, mode, parent) {
      return this.openMsgModal(item, mode, "reply", parent);
    };

    Board.prototype.sendMessage = function() {
      var _opts, d, err, home, modalOpts, msgModal, opts, promise;
      _opts = this._opts;
      msgModal = this.getShownModal();
      opts = msgModal.opts;
      modalOpts = _opts[opts.type];
      err = modalOpts.validate(opts.item);
      if (err) {
        return notifier.message(err);
      } else {
        home = _opts.board.spot;
        d = modalOpts.map2send(opts.item);
        promise = null;
        if (opts.type === "thread") {
          if (opts.mode === "create") {
            promise = boardDA.postThread({
              spot: home,
              board: opts.boardName
            }, d).then((function(_this) {
              return function(res) {
                return _this.data.threads.splice(0, 0, res);
              };
            })(this));
          } else if (opts.mode === "edit") {
            promise = boardDA.putThread(opts.item._id, d).then((function(_this) {
              return function(res) {
                _this.data.threads.splice(_this.data.threads.indexOf(opts.item), 1, res);
                if (_this.data.currentThread) {
                  return _this.data.currentThread.data = res.data;
                }
              };
            })(this));
          }
        } else if (opts.type === "reply") {
          if (opts.mode === "create") {
            promise = boardDA.postReply(opts.item, d);
          } else if (opts.mode === "edit") {
            promise = boardDA.putReply(opts.item, opts.parent, d);
          }
        }
        if (typeof modalOpts.reset === "function") {
          modalOpts.reset(opts.item);
        }
        return promise != null ? promise.then(function() {
          return msgModal.hide();
        }) : void 0;
      }
    };

    Board.prototype.cancelMsgModal = function() {
      var modalOpts, msgModal, opts;
      msgModal = this.getShownModal();
      opts = msgModal.opts;
      modalOpts = this._opts[opts.type];
      if (typeof modalOpts.reset === "function") {
        modalOpts.reset(opts.item);
      }
      return msgModal.hide();
    };

    Board.prototype.openFilterModal = function() {
      return this._filterModal.show();
    };

    Board.prototype.cancelFilterModal = function() {
      return this._filterModal.hide();
    };

    Board.prototype.filter = function() {
      this.clean();
      return this._filterModal.hide().then((function(_this) {
        return function() {
          return _this.loadBoard();
        };
      })(this)).then(function() {
        user.setMsgsFilter(filterMsgsFormScope.serialize());
        return $ionicScrollDelegate.scrollTop(false);
      });
    };

    Board.prototype.restoreFilter = function(data) {
      return filterMsgsFormScope.deserialize(data);
    };

    Board.prototype.requestTransfer = function(thread) {
      return user.login().then(function() {
        return boardDA.requestTransfer(thread);
      });
    };

    Board.prototype.unrequestTransfer = function(thread) {
      return notifier.confirm("unrequest_transfer").then(function(f) {
        if (!f) {
          return $q.reject();
        } else {
          return user.login();
        }
      }).then(function() {
        return boardDA.unrequestTransfer(thread);
      });
    };

    Board.prototype.userRequestStatus = function(thread) {
      var userRequest;
      if (thread.requests) {
        userRequest = thread.requests.filter(function(f) {
          return f.user.key === user.getKey();
        })[0];
        if (userRequest) {
          if (userRequest.accepted === true) {
            return "accepted";
          } else if (userRequest.accepted === false) {
            return "rejected";
          } else {
            return "requested";
          }
        }
      }
      return "none";
    };

    Board.prototype.switchAccepted = function(thread, request) {
      var f;
      f = !request.accepted;
      return boardDA.acceptTransferRequest(thread, request, f);
    };

    return Board;

  })();
  return {
    Board: Board,
    filterMsgsFormScope: filterMsgsFormScope.scope
  };
});

app.factory("boardThreadHeight", function(boardThreadType, $interpolate) {
  var calcDim, getFaqHeigth, getImageHeigth, getMessageHeigth, getReportHeigth, getThreadContentDim, getTransferHeigth;
  calcDim = function(template, scope, containerElement) {
    var exp, html, newElement, offsetHeight, offsetWidth;
    exp = $interpolate(template);
    html = exp(scope);
    html = "<div class='item item-text-wrap' style='width: 100%; position: absolute;'>" + html + "</div>";
    newElement = angular.element(html);
    newElement.css(ionic.CSS.TRANSFORM, 'translate3d(-2000px,-2000px,0)');
    containerElement.append(newElement);
    offsetHeight = newElement[0].offsetHeight;
    offsetWidth = newElement[0].children[0].offsetWidth;
    newElement.remove();
    return {
      width: offsetWidth,
      height: offsetHeight
    };
  };
  getThreadContentDim = function(thread, containerElement) {
    return calcDim(boardThreadType.getThreadTemplate(thread), {
      thread: thread
    }, containerElement);
  };
  getImageHeigth = function(thread, contentWidth) {
    var dim, h, height, match, regex, spts, width;
    if (thread.data.img) {
      regex = /^.*-(\d{1,4}x\d{1,4})\.(gif|jpg|png)$/g;
      match = regex.exec(thread.data.img);
      if (match) {
        dim = match[1];
        spts = dim.split("x");
        width = parseInt(spts[0]);
        height = parseInt(spts[1]);
        h = (contentWidth / width) * height;
        return h;
      } else {
        return 300;
      }
    }
    return 0;
  };
  getMessageHeigth = function(thread, containerElement) {
    var contentDim, imgHeight;
    contentDim = getThreadContentDim(thread, containerElement);
    imgHeight = getImageHeigth(thread, contentDim.width);
    return contentDim.height + imgHeight;
  };
  getReportHeigth = function(thread, containerElement) {
    return getThreadContentDim(thread, containerElement).height;
  };
  getTransferHeigth = function(thread, containerElement) {
    return getThreadContentDim(thread, containerElement).height;
  };
  getFaqHeigth = function(thread, containerElement) {
    return getThreadContentDim(thread, containerElement).height;
  };
  return {
    getHeight: function(thread, containerElement) {
      var height, ref;
      if ((ref = thread.__meta) != null ? ref.listItemHeight : void 0) {
        return thread.__meta.listItemHeight;
      }
      height = (function() {
        switch (boardThreadType.getThreadType(thread)) {
          case "message":
            return getMessageHeigth(thread, containerElement);
          case "report":
            return getReportHeigth(thread, containerElement);
          case "faq":
            return getTransferHeigth(thread, containerElement);
          case "transfer":
            return getTransferHeigth(thread, containerElement);
        }
      })();
      if (thread.__meta == null) {
        thread.__meta = {};
      }
      thread.__meta.listItemHeight = height;
      return height;
    },
    getReplyHeight: function(reply, containerElement) {
      return calcDim(boardThreadType.getReplyTemplate(), {
        reply: reply
      }, containerElement).height;
    }
  };
});

app.factory("boardThreadType", function($templateCache) {
  return {
    isThreadOfType: function(thread, type) {
      if (typeof thread === "string") {
        return thread === type;
      } else {
        return thread.tags.indexOf(type) !== -1;
      }
    },
    getThreadType: function(thread) {
      if (this.isThreadOfType(thread, "faq")) {
        return "faq";
      } else if (this.isThreadOfType(thread, "message")) {
        return "message";
      } else if (this.isThreadOfType(thread, "transfer")) {
        return "transfer";
      } else if (this.isThreadOfType(thread, "report")) {
        return "report";
      }
    },
    getThreadTemplate: function(thread) {
      return $templateCache.get("messages/" + (this.getThreadType(thread)) + "-list-item.html");
    },
    getThreadItemTemplate: function(thread) {
      var type;
      type = this.getThreadType(thread);
      if (type === "report") {
        type = "reports";
      }
      if (type === "message") {
        type = "messages";
      }
      return $templateCache.get("messages/" + type + "-item.html");
    },
    getReplyTemplate: function() {
      return $templateCache.get("messages/reply-item.html");
    }
  };
});

app.factory("boardCache", function($rootScope) {
  var _latestBoard;
  _latestBoard = null;
  $rootScope.$on("::board.thread.add", function(e, prms) {
    var thread;
    thread = prms.thread;
    console.log("boardCache.coffee:7 >>>", prms);
    return _latestBoard != null ? _latestBoard.res.splice(0, 0, thread) : void 0;
  });
  $rootScope.$on("::board.thread.remove", function(e, prms) {
    var thread;
    thread = prms.thread;
    console.log("boardCache.coffee:12 >>>", prms);
    return _latestBoard != null ? _latestBoard.res.splice(_latestBoard.res.indexOf(thread), 1) : void 0;
  });
  return {
    put: function(filter, res) {
      if (res.length) {
        return _latestBoard = {
          filter: filter,
          res: res
        };
      }
    },
    get: function(filter) {
      if ((_latestBoard != null ? _latestBoard.filter : void 0) === filter) {
        return _latestBoard.res;
      }
    },
    getThread: function(id) {
      if (_latestBoard) {
        return _latestBoard.res.filter(function(f) {
          return f._id === id;
        })[0];
      }
    }
  };
});

app.factory("cacheManager", function(homeCache, boardCache) {
  return {
    ok: true
  };
});

var FifoArray;

FifoArray = (function() {
  function FifoArray(max) {
    this.max = max;
    this.arr = [];
  }

  FifoArray.prototype.push = function(el) {
    while (this.arr.length > this.max) {
      this.arr.pop();
    }
    return this.arr.splice(0, 0, el);
  };

  FifoArray.prototype.arr = FifoArray.arr;

  return FifoArray;

})();

app.factory("fifoService", function() {
  return {
    Fifo: FifoArray
  };
});

app.factory("homeCache", function($rootScope, cache) {
  var getCacheName;
  getCacheName = function() {
    return "home-latest";
  };
  console.log("homeCache.coffee:5 >>>");
  $rootScope.$on("user::propertyChanged", function(e, prms) {
    console.log("homeCache.coffee:6 >>>");
    return cache.rm(getCacheName());
  });
  console.log("homeCache.coffee:11 >>>");
  $rootScope.$on("::board.thread.add", function(e, prms) {
    console.log("homeCache.coffee:9 >>>", prms);
    if (prms.thread.tags.indexOf("report") !== -1) {
      return cache.rm(getCacheName());
    }
  });
  $rootScope.$on("::board.thread.remove", function(e, prms) {
    if (prms.thread.tags.indexOf("report") !== -1) {
      console.log("homeCache.coffee:13 >>>", "remove");
      return cache.rm(getCacheName());
    }
  });
  return {
    put: function(spot, val) {
      return cache.put(getCacheName(), {
        spot: spot,
        val: val
      }, 5);
    },
    get: function(spot) {
      var cached;
      cached = cache.get(getCacheName());
      console.log("homeCache.coffee:19 >>>", cached);
      if ((cached != null ? cached.spot : void 0) === spot) {
        return cached.val;
      }
    }
  };
});

app.factory("snowHistCache", function() {
  var _latestHist;
  _latestHist = null;
  return {
    put: function(spot, res) {
      return _latestHist = {
        spot: spot,
        res: res
      };
    },
    get: function(spot) {
      var cached;
      if ((_latestHist != null ? _latestHist.spot : void 0) === spot) {
        return _latestHist.res;
      } else if (_latestHist && spot.indexOf("-") === -1) {
        cached = _latestHist.res.filter(function(f) {
          return f.spot === spot;
        })[0];
        console.log("snowHistCache.coffee:15 >>>", cached);
        if (cached) {
          return [cached];
        }
      }
    }
  };
});

app.factory("threadsPoolService", function(fifoService, threadMapper) {
  var _fifo, get;
  _fifo = new fifoService.Fifo(500);
  get = function(id) {
    var f, i, len, ref;
    ref = _fifo.arr;
    for (i = 0, len = ref.length; i < len; i++) {
      f = ref[i];
      if (f._id === id) {
        return f;
      }
    }
  };
  return {
    get: get,
    fifo: _fifo,
    push: function(threads) {
      var _thread, existed, i, isArray, len, res, thread;
      res = [];
      isArray = Array.isArray(threads);
      if (!isArray) {
        threads = [threads];
      }
      for (i = 0, len = threads.length; i < len; i++) {
        _thread = threads[i];
        thread = threadMapper.mapThread(_thread);
        existed = get(thread._id);
        if (existed) {
          if (thread !== existed) {
            angular.copy(thread, existed);
          }
          res.push(existed);
        } else {
          _fifo.push(thread);
          res.push(thread);
        }
      }
      if (isArray) {
        return res;
      } else {
        return res[0];
      }
    }
  };
});

app.factory("cordovaCamera", function($q) {
  var getFile, getFileEntry, takePicture;
  getFile = function(fileEntry) {
    var deferred;
    deferred = $q.defer();
    fileEntry.file(deferred.resolve, deferred.reject);
    return deferred.promise;
  };
  getFileEntry = function(url) {
    var deferred;
    deferred = $q.defer();
    window.resolveLocalFileSystemURL(url, deferred.resolve, deferred.reject);
    return deferred.promise;
  };
  takePicture = function(isFromGallery) {
    var deferred, opts, pictureSourceType;
    console.log(isFromGallery);
    pictureSourceType = isFromGallery ? Camera.PictureSourceType.PHOTOLIBRARY : Camera.PictureSourceType.CAMERA;
    deferred = $q.defer();
    opts = {
      destinationType: Camera.DestinationType.FILE_URL,
      sourceType: pictureSourceType,
      encodingType: Camera.EncodingType.JPEG,
      quality: 50
    };
    navigator.camera.getPicture(deferred.resolve, deferred.reject, opts);
    return deferred.promise;
  };
  return {
    takePicture: takePicture,
    getPictureFile: function(isFromGallery) {
      if (window.cordova) {
        return takePicture(isFromGallery).then(function(url) {
          return getFileEntry(url).then(function(fileEntry) {
            return [url, fileEntry];
          });
        }).then(function(res) {
          return getFile(res[1]).then(function(file) {
            return [res[0], file];
          });
        }).then(function(res) {
          return {
            url: res[0],
            file: res[1]
          };
        });
      } else {
        return $q.reject(new Error("Skip getPicture since in browser"));
      }
    }
  };
});

app.factory("cordovaFileTransfer", function($q) {
  return {
    upload: function(url, fileURL, data, headers) {
      var deferred, fail, ft, options, win;
      options = new FileUploadOptions();
      options.fileKey = "file";
      options.fileName = fileURL.substr(fileURL.lastIndexOf('/') + 1);
      options.mimeType = "text/plain";
      options.params = data;
      options.headers = headers;
      console.log(options.fileName);
      deferred = $q.defer();
      win = function(res) {
        return deferred.resolve(res);
      };
      fail = function(err) {
        return deferred.reject(err);
      };
      ft = new FileTransfer();
      ft.upload(fileURL, encodeURI(url), win, fail, options);
      return deferred.promise;
    }
  };
});

app.factory("boardDA", function(boardEP, $q, $rootScope, threadMapper, threadsPoolService) {
  var saveThread;
  saveThread = function(method, opts, data) {
    var file, imgSrc, promise;
    if (!data.img || (!data.img.file && !data.img.url)) {
      data = angular.copy(data);
      if (data.img && data.img.src) {
        imgSrc = data.img.src;
        delete data.img;
        data.img = imgSrc;
      } else {
        delete data.img;
      }
      promise = boardEP[method + "Thread"](opts, data);
    } else {
      file = data.img.url ? data.img.url : data.img.file;
      data = angular.copy(data);
      delete data.img;
      promise = boardEP[method + "ThreadImg"](opts, file, data);
    }
    return promise.then(threadsPoolService.push);
  };
  return {
    postThread: function(opts, data) {
      return saveThread("post", opts, data);
    },
    putThread: function(opts, data) {
      return saveThread("put", opts, data);
    },
    get: function(prms, opts) {
      return boardEP.get(prms, opts).then(function(res) {
        return threadsPoolService.push(res);
      });
    },
    getThread: function(id, opts) {
      var existed;
      existed = threadsPoolService.get(id);
      if (existed) {
        return $q.when(existed);
      }
      return boardEP.getThread(id, opts).then(threadsPoolService.push);
    },
    removeThread: function(thread) {
      return boardEP.removeThread(thread._id);
    },
    requestTransfer: function(thread) {
      return boardEP.requestTransfer(thread._id).then(function(res) {
        if (thread.requests == null) {
          thread.requests = [];
        }
        thread.requests.push(res);
        return threadsPoolService.push(thread);
      });
    },
    unrequestTransfer: function(thread) {
      return boardEP.unrequestTransfer(thread._id).then(function(res) {
        var ix;
        if (thread.requests == null) {
          thread.requests = [];
        }
        ix = thread.requests.indexOf(thread.requests.filter(function(f) {
          return f.user.key === res.user.key;
        })[0]);
        if (ix !== -1) {
          thread.requests.splice(ix, 1);
        }
        return threadsPoolService.push(thread);
      });
    },
    acceptTransferRequest: function(thread, userRequest, f) {
      return boardEP.acceptTransferRequest(thread._id, userRequest.user.key, f).then(function() {
        userRequest.accepted = f;
        return threadsPoolService.push(thread);
      });
    },
    removeReply: function(reply, thread) {
      return boardEP.removeReply(reply._id).then(function() {
        thread.replies.splice(thread.replies.indexOf(reply), 1);
        return threadsPoolService.push(thread);
      });
    },
    postReply: function(thread, data) {
      return boardEP.postReply(thread._id, data).then(function(res) {
        thread.replies.splice(0, 0, threadMapper.mapReply(res));
        return threadsPoolService.push(thread);
      });
    },
    putReply: function(reply, thread, data) {
      return boardEP.putReply(reply._id, data).then(function(res) {
        reply.data.text = data.message;
        return threadsPoolService.push(thread);
      });
    }
  };
});

app.factory("histDA", function(histEP, snowHistCache, $q) {
  return {
    getSnowfall: function(spot, favs) {
      var cached;
      cached = snowHistCache.get(spot);
      if (cached) {
        return $q.when(cached);
      }
      return histEP.getSnowfall(favs).then(function(res) {
        snowHistCache.put(favs, res);
        return snowHistCache.get(spot);
      });
    }
  };
});

app.factory("homeDA", function(homeEP, $q, threadsPoolService) {
  var mapHome;
  mapHome = function(home) {
    if (home.reports == null) {
      home.reports = [];
    }
    if (home.latestImportant == null) {
      home.latestImportant = [];
    }
    home.reports = threadsPoolService.push(home.reports);
    home.latestImportant = threadsPoolService.push(home.latestImportant);
    home.snapshot.lastImportant = home.latestImportant[0];
    return home;
  };
  return {
    get: function(opts) {
      return homeEP.get(opts).then(mapHome);
    }
  };
});

app.factory("pricesDA", function(resortsDA) {
  return {
    get: function(spot) {
      return resortsDA.getInfo(spot);
    }
  };
});

app.factory("resortsDA", function(resortsEP, $q, cache) {
  var getCacheName, getImg, mapInfo;
  getImg = function(img) {
    return {
      thumb: img,
      orig: img != null ? img.replace(/thumbnail-/, "original-") : void 0
    };
  };
  getCacheName = function(spot) {
    return "resort_" + spot;
  };
  mapInfo = function(info) {
    var i, j, len, len1, map, price, ref, ref1;
    info.headerImg = getImg(info.header);
    ref = info.prices;
    for (i = 0, len = ref.length; i < len; i++) {
      price = ref[i];
      price.img = getImg(price.src);
    }
    ref1 = info.maps;
    for (j = 0, len1 = ref1.length; j < len1; j++) {
      map = ref1[j];
      map.img = getImg(map.src);
    }
    return info;
  };
  return {
    getInfo: function(spot) {
      var cacheName, cached;
      cacheName = getCacheName(spot);
      cached = cache.get(cacheName);
      if (cached) {
        return $q.when(cached);
      } else {
        return resortsEP.getInfo(spot).then(function(res) {
          res = mapInfo(res);
          cache.put(cacheName, res, 60 * 3);
          return res;
        });
      }
    },
    getMaps: resortsEP.getMaps,
    getPrices: resortsEP.getPrices,
    postPrice: resortsEP.postPrice
  };
});

app.factory("spotsDA", function($q, spotsEP, cache, cultureFormatter, resources) {
  var formatFind, getCacheName;
  getCacheName = function(spot) {
    return "spot_" + spot;
  };
  formatFind = function(spot, cult) {
    spot.formatted = {
      dist: cultureFormatter.dist(spot.dist, cult.units),
      distU: resources.str(cultureFormatter.distU(cult.units))
    };
    return spot;
  };
  return {
    get: function(spot) {
      var cacheName, cached;
      cacheName = getCacheName(spot);
      cached = cache.get(cacheName);
      if (cached) {
        return $q.when(cached);
      } else {
        return spotsEP.get(spot).then(function(res) {
          cache.put(cacheName, res, 60 * 24 * 2);
          return res;
        });
      }
    },
    find: function(term, geo, cult) {
      return spotsEP.find(term, geo).then(function(res) {
        return res.map(function(m) {
          return formatFind(m, cult);
        });
      });
    },
    nearest: spotsEP.nearest
  };
});

app.factory("threadMapper", function(user, amCalendarFilter, amDateFormatFilter, resources) {
  var getImg, mapReply, mapThread, trimText, userRequestStatus;
  trimText = function(text) {
    if ((text != null ? text.length : void 0) > 300) {
      return text.slice(0, 300) + "...";
    } else {
      return text;
    }
  };
  getImg = function(thread) {
    var img;
    img = thread.data.img;
    if (img) {
      return {
        thumb: thread.tmpImg ? thread.tmpImg : img,
        orig: img.replace(/thumbnail-/, "original-")
      };
    }
  };
  mapReply = function(reply) {
    reply.formatted = {
      shortText: reply.data.text ? trimText(reply.data.text) : void 0,
      createdStr: amCalendarFilter(reply.created),
      canEdit: user.isUser(reply.user)
    };
    return reply;
  };
  userRequestStatus = function(thread) {
    var userRequest;
    if (thread.requests) {
      userRequest = thread.requests.filter(function(f) {
        return f.user.key === user.getKey();
      })[0];
      if (userRequest) {
        if (userRequest.accepted === true) {
          return "accepted";
        } else if (userRequest.accepted === false) {
          return "rejected";
        } else {
          return "requested";
        }
      }
    }
  };
  mapThread = function(thread) {
    var i, len, ref, ref1, ref2, ref3, reply;
    thread.repliesCount = (ref = thread.replies) != null ? ref.length : void 0;
    thread.formatted = {
      createdStr: amCalendarFilter(thread.created),
      shortText: thread.data ? trimText(thread.data.text) : void 0,
      metaDateStrLong: ((ref1 = thread.data) != null ? (ref2 = ref1.meta) != null ? ref2.date : void 0 : void 0) ? amDateFormatFilter(thread.data.meta.date, 'dddd, MMMM Do YYYY, HH:00') : void 0,
      img: thread.data ? getImg(thread) : void 0,
      canEdit: user.isUser(thread.user)
    };
    if (thread.tags.indexOf("transfer") !== -1 && thread.data) {
      thread.formatted.transfer = {
        title: resources.str(thread.data.meta.type) + " - " + resources.str(thread.data.meta.transport),
        requestStatus: userRequestStatus(thread)
      };
    }
    ref3 = thread.replies;
    for (i = 0, len = ref3.length; i < len; i++) {
      reply = ref3[i];
      mapReply(reply);
    }
    thread.latestReply = thread.replies[0];
    return thread;
  };
  return {
    mapThread: mapThread,
    mapReply: mapReply
  };
});

app.factory("webcamsDA", function(webcamsEP, mobileDetect) {
  return {
    latest: function(opts) {
      if (mobileDetect.isMobile()) {
        opts.nostream = true;
      }
      return webcamsEP.latest(opts);
    },
    prev: function(opts) {
      if (mobileDetect.isMobile()) {
        opts.nostream = true;
      }
      return webcamsEP.prev(opts);
    },
    next: function(opts) {
      if (mobileDetect.isMobile()) {
        opts.nostream = true;
      }
      return webcamsEP.next(opts);
    }
  };
});

app.factory("boardEP", function(_ep) {
  return {
    get: function(opts, prms) {
      var url;
      url = "spots/" + opts.spot + "/boards";
      if (opts.board) {
        url += "/" + opts.board;
      }
      return _ep.get(url, prms);
    },
    postThread: function(opts, data) {
      return _ep.post("spots/" + opts.spot + "/boards/" + opts.board + "/threads", data, true);
    },
    postThreadImg: function(opts, file, data) {
      return _ep.postFile("spots/" + opts.spot + "/boards/" + opts.board + "/threads/img", file, data, true);
    },
    putThread: function(threadId, data) {
      return _ep.put("spots/boards/threads/" + threadId, data, true);
    },
    putThreadImg: function(threadId, file, data) {
      return _ep.putFile("spots/boards/threads/" + threadId + "/img", file, data, true);
    },
    removeThread: function(threadId) {
      return _ep.remove("spots/boards/threads/" + threadId, true);
    },
    getThread: function(threadId, opts) {
      return _ep.get("spots/boards/threads/" + threadId, opts);
    },
    postReply: function(threadId, data) {
      return _ep.post("spots/boards/threads/" + threadId + "/replies", data, true);
    },
    putReply: function(replyId, data) {
      return _ep.put("spots/boards/threads/replies/" + replyId, data, true);
    },
    removeReply: function(replyId) {
      return _ep.remove("spots/boards/threads/replies/" + replyId, true);
    },
    requestTransfer: function(threadId) {
      return _ep.post("transfers/" + threadId + "/request", null, true);
    },
    unrequestTransfer: function(threadId) {
      return _ep.remove("transfers/" + threadId + "/request", true);
    },
    acceptTransferRequest: function(threadId, requestUserKey, f) {
      return _ep.put("transfers/" + threadId + "/requests/" + requestUserKey + "/" + (f ? "accept" : "reject"), null, true);
    }
  };
});

app.factory("histEP", function(_ep) {
  return {
    getSnowfall: function(spots) {
      console.log("hist::getSnowfall", spots);
      return _ep.get("spots/" + spots + "/snowfall-history");
    }
  };
});

app.factory("homeEP", function(_ep) {
  return {
    get: function(opts) {
      console.log("home::get", opts);
      return _ep.get("home/" + opts.spot, {
        lang: opts.lang,
        culture: opts.culture
      });
    }
  };
});

app.factory("platformsEP", function(_ep) {
  return {
    register: function(platform) {
      return _ep.post("platforms/" + platform.platform + "/" + platform.token);
    }
  };
});

app.factory("reportsEP", function(_ep) {
  return {
    send: function(spot, data) {
      return _ep.post("reports/" + spot, data, true);
    },
    get: function(spot, opts) {
      return _ep.get("reports/" + spot, opts);
    }
  };
});

app.factory("resortsEP", function(_ep) {
  return {
    getInfo: function(spot) {
      return _ep.get("resorts/" + spot + "/info");
    },
    getMaps: function(spot) {
      return _ep.get("resorts/" + spot + "/maps");
    },
    getPrices: function(spot) {
      return _ep.get("resorts/" + spot + "/prices");
    },
    postPrice: function(spot, file, data) {
      return _ep.postFile("resorts/" + spot + "/price", file, data, true);
    }
  };
});

app.factory("spotsEP", function(_ep) {
  return {
    get: function(spot) {
      return _ep.get("spots/" + spot);
    },
    find: function(term, geo) {
      return _ep.get("spots", {
        term: term,
        geo: geo
      });
    },
    nearest: function(geo) {
      return _ep.get("nearest-spots", {
        geo: geo
      });
    }
  };
});

app.factory("webcamsEP", function(_ep) {
  return {
    latest: function(opts) {
      console.log("webcams::latest", opts);
      return _ep.get(["webcams", opts.spot, opts.index, "latest"], {
        nostream: opts.nostream
      });
    },
    prev: function(opts) {
      console.log("webcams::prev", opts);
      return _ep.get("webcams/" + opts.spot + "/" + opts.index + "/prev/" + opts.time, {
        nostream: opts.nostream
      });
    },
    next: function(opts) {
      console.log("webcams::next", opts);
      return _ep.get("webcams/" + opts.spot + "/" + opts.index + "/next/" + opts.time, {
        nostream: opts.nostream
      });
    }
  };
});

app.factory("_ep", function($q, $http, webApiConfig, authio, notifier, fileUploadService) {
  
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
  ;
  var getAuthHeaders, save, saveFile;
  getAuthHeaders = function() {
    return {
      authorization: "Bearer " + authio.getJWT()
    };
  };
  save = function(method, path, data, useAuth) {
    var deferred, headers, inProgress;
    deferred = $q.defer();
    inProgress = false;
    if (inProgress) {
      deferred.reject(new Error("In progress"));
    } else {
      notifier.showLoading();
      inProgress = true;
      if (useAuth) {
        headers = {
          headers: getAuthHeaders()
        };
      }
      $http[method](webApiConfig.url + path, data, headers).success(function(data) {
        inProgress = false;
        return deferred.resolve(data);
      }).error(function(data) {
        return deferred.reject(data);
      })["finally"](function() {
        inProgress = false;
        return notifier.hideLoading();
      });
    }
    return deferred.promise;
  };
  saveFile = function(method, path, file, data, useAuth) {
    var headers, inProgress;
    inProgress = false;
    if (inProgress) {
      deferred.reject(new Error("In progress"));
    } else {
      notifier.showLoading();
      inProgress = true;
    }
    if (useAuth) {
      headers = getAuthHeaders();
    }
    return fileUploadService.upload(webApiConfig.url + path, file, data, headers, method).then(function(res) {
      return res.data;
    })["finally"](function() {
      inProgress = false;
      return notifier.hideLoading();
    });
  };
  return {
    get: function(path, qs) {
      var deferred, inProgress;
      if (Array.isArray(path)) {
        path = urljoin(path);
      }
      deferred = $q.defer();
      inProgress = false;
      if (inProgress) {
        deferred.reject(new Error("In progress"));
      } else {
        notifier.showLoading();
        inProgress = true;
        $http.get(webApiConfig.url + path, {
          params: qs
        }).success(deferred.resolve).error(deferred.reject)["finally"](function() {
          inProgress = false;
          return notifier.hideLoading();
        });
      }
      return deferred.promise;
    },
    post: function(path, data, useAuth) {
      return save("post", path, data, useAuth);
    },
    put: function(path, data, useAuth) {
      return save("put", path, data, useAuth);
    },
    remove: function(path, useAuth) {
      var deferred, headers, inProgress;
      deferred = $q.defer();
      inProgress = false;
      if (inProgress) {
        deferred.reject(new Error("In progress"));
      } else {
        notifier.showLoading();
        inProgress = true;
        if (useAuth) {
          headers = {
            headers: getAuthHeaders()
          };
        }
        $http["delete"](webApiConfig.url + path, headers).success(function(data) {
          inProgress = false;
          return deferred.resolve(data);
        }).error(function(data) {
          return deferred.reject(data);
        })["finally"](function() {
          inProgress = false;
          return notifier.hideLoading();
        });
      }
      return deferred.promise;
    },
    postFile: function(path, file, data, useAuth) {
      return saveFile("post", path, file, data, useAuth);
    },
    putFile: function(path, file, data, useAuth) {
      return saveFile("put", path, file, data, useAuth);
    }
  };
});

app.service("filterMsgsFormScope", function() {
  var scope;
  scope = {
    data: {
      spots: "favs",
      messages: true,
      reports: true,
      faq: true,
      transfers: true
    },
    setActiveFilter: function(filter) {
      if (filter !== this.data.spots) {
        return this.data.spots = filter;
      }
    },
    isActiveFilter: function(filter) {
      return this.data.spots === filter;
    }
  };
  return {
    scope: scope,
    serialize: function() {
      var boards;
      boards = [];
      if (scope.data.messages) {
        boards.push("message");
      }
      if (scope.data.reports) {
        boards.push("report");
      }
      if (scope.data.faq) {
        boards.push("faq");
      }
      if (scope.data.transfers) {
        boards.push("transfer");
      }
      return {
        spots: scope.data.spots,
        boards: boards.join(",")
      };
    },
    deserialize: function(data) {
      var board, i, len, ref, results;
      console.log("filterMsgsFormScope.coffee:35 >>>", data);
      if (data.spots) {
        scope.data.spots = data.spots;
      }
      if (data.boards) {
        scope.data.messages = false;
        scope.data.reports = false;
        scope.data.faq = false;
        scope.data.transfers = false;
        ref = data.boards.split(",");
        results = [];
        for (i = 0, len = ref.length; i < len; i++) {
          board = ref[i];
          switch (board) {
            case "message":
              results.push(scope.data.messages = true);
              break;
            case "report":
              results.push(scope.data.reports = true);
              break;
            case "faq":
              results.push(scope.data.faq = true);
              break;
            case "transfer":
              results.push(scope.data.transfers = true);
              break;
            default:
              results.push(void 0);
          }
        }
        return results;
      }
    }
  };
});

app.service("reportFormScope", function() {
  var scope;
  scope = {
    data: {
      message: null,
      meta: null
    }
  };
  scope.validate = function() {
    if (!scope.data.message) {
      return "message_required";
    }
  };
  scope.reset = function() {
    scope.data.message = null;
    return scope.data.meta = null;
  };
  scope.getSendThreadData = function() {
    return {
      message: scope.data.message,
      meta: scope.data.meta
    };
  };
  return {
    scope: scope
  };
});

app.service("sendMsgFormScope", function(resources, imageService, notifier) {
  var getPhoto, scope;
  scope = {
    data: {
      message: null,
      priority: null,
      photo: {
        src: null,
        url: null,
        dataUrl: null
      }
    },
    prioritiesList: [
      {
        code: "important",
        name: resources.str("important")
      }, {
        code: "normal",
        name: resources.str("normal")
      }
    ]
  };
  getPhoto = function(isFromGallery) {
    notifier.showLoading();
    return imageService.takePicture(isFromGallery).then(function(url) {
      if (url) {
        scope.data.photo.src = url;
        return scope.data.photo.url = url;
      }
    })["finally"](function() {
      return notifier.hideLoading();
    });
  };
  scope.validate = function() {
    if (!scope.data.message) {
      return "message_required";
    }
  };
  scope.reset = function() {
    return scope.data = {
      message: null,
      priority: null,
      photo: {
        src: null,
        url: null,
        dataUrl: null
      }
    };
  };
  scope.takePhoto = function() {
    return getPhoto(false);
  };
  scope.selectPhoto = function() {
    return getPhoto(true);
  };
  scope.attachPhoto = function(files) {
    if (files.length) {
      return imageService.getPictureFromFile(files[0]).then(function(pic) {
        scope.data.photo.file = pic.file;
        return scope.data.photo.src = pic.dataUrl;
      });
    }
  };
  scope.removePhoto = function(files) {
    return scope.data.photo = {
      file: null,
      url: null,
      src: null
    };
  };
  scope.getSendThreadData = function() {
    var data;
    data = {
      message: scope.data.message,
      img: scope.data.photo
    };
    if (scope.data.priority && scope.data.priority.code !== "normal") {
      data.meta = {
        priority: scope.data.priority.code
      };
    }
    return data;
  };
  return {
    scope: scope
  };
});

app.service("sendSimpleMsgFormScope", function() {
  var scope;
  scope = {
    data: {
      message: null,
      meta: void 0
    }
  };
  scope.validate = function() {
    if (!scope.data.message) {
      return "message_required";
    }
  };
  scope.reset = function() {
    scope.data.message = null;
    return scope.data.meta = void 0;
  };
  scope.getSendThreadData = function() {
    return {
      message: scope.data.message,
      meta: scope.data.meta
    };
  };
  return {
    scope: scope
  };
});

app.service("transferFormScope", function(resources) {
  var i, results, scope;
  scope = {
    data: {
      message: null,
      from: null,
      date: new Date(),
      time: null,
      transport: null,
      price: null,
      phone: null
    },
    transportTypesList: [
      {
        code: "car",
        name: resources.str("car")
      }, {
        code: "micro",
        name: resources.str("micro_bus")
      }, {
        code: "bus",
        name: resources.str("bus")
      }
    ],
    typesList: [
      {
        code: "private",
        name: resources.str("private")
      }, {
        code: "taxi",
        name: resources.str("taxi")
      }, {
        code: "regular",
        name: resources.str("regular")
      }
    ],
    hoursList: (function() {
      results = [];
      for (i = 1; i <= 24; i++){ results.push(i); }
      return results;
    }).apply(this).map(function(m) {
      return {
        val: m,
        label: m.toString()
      };
    })
  };
  scope.data.time = scope.hoursList[11];
  scope.data.transport = scope.transportTypesList[0];
  scope.data.type = scope.typesList[0];
  scope.validate = function() {
    if (!scope.data.from) {
      return "from_town_required";
    }
  };
  scope.reset = function() {
    console.log("transferFormScope.coffee:33 >>>");
    return scope.data = {
      message: null,
      from: null,
      date: new Date(),
      price: null,
      phone: null,
      time: scope.hoursList[11],
      type: scope.typesList[0],
      transport: scope.transportTypesList[0]
    };
  };
  scope.getSendThreadData = function() {
    var date, meta;
    meta = angular.copy(scope.data);
    if (meta.date && meta.type.code !== "taxi") {
      date = moment(meta.date).startOf("d");
      date.add(meta.time.val, "h");
      meta.date = date.utc().unix();
    } else {
      meta.date = void 0;
    }
    meta.type = meta.type.code;
    meta.transport = meta.transport.code;
    delete meta.time;
    delete meta.message;
    return {
      message: scope.data.message,
      validThru: meta.date,
      meta: meta
    };
  };
  return {
    scope: scope
  };
});

app.factory("resources", function($rootScope, strings_ru, strings_en) {
  var _lang;
  $rootScope.resources = {
    str: {}
  };
  angular.copy(strings_en, $rootScope.resources.str);
  _lang = "en";
  return {
    str: function(str) {
      return $rootScope.resources.str[str];
    },
    setLang: function(lang) {
      _lang = _lang;
      switch (lang) {
        case "en":
          return angular.copy(strings_en, $rootScope.resources.str);
        case "ru":
          return angular.copy(strings_ru, $rootScope.resources.str);
      }
    },
    getKnownLang: function(lang) {
      if (lang === "ru") {
        return lang;
      } else {
        return "en";
      }
    }
  };
});

"use strict";
var baioNgCordova;

baioNgCordova = angular.module('baio-ng-cordova', []);

"use strict";
baioNgCordova.factory("cordovaAdmob", function() {
  var failureCallback, requestAd, requestSuccessCallback, rqeuestFailureCallback, showAd, showFailureCallback, showSuccessCallback, startAd, successCallback;
  successCallback = function() {
    console.log("add mob created");
    return requestAd();
  };
  failureCallback = function(err) {
    return console.log("add mob failed", err);
  };
  requestSuccessCallback = function() {
    console.log("requestSuccessCallback suc");
    return showAd();
  };
  rqeuestFailureCallback = function(err) {
    return console.log("rqeuestFailureCallback", err);
  };
  showSuccessCallback = function() {
    return console.log("showSuccessCallback");
  };
  showFailureCallback = function(err) {
    return console.log("showFailureCallback", err);
  };
  requestAd = function() {
    return window.plugins.AdMob.requestAd({
      isTesting: true,
      extras: {
        color_bg: 'AAAAFF',
        color_bg_top: 'FFFFFF',
        color_border: 'FFFFFF',
        color_link: '000080',
        color_text: '808080',
        color_url: '008000'
      }
    }, requestSuccessCallback, rqeuestFailureCallback);
  };
  showAd = function() {
    console.log("showAd");
    return window.plugins.AdMob.showAd(true, showSuccessCallback, showFailureCallback);
  };
  startAd = function(appkeys) {
    var appkey;
    if (window.plugins && window.plugins.AdMob) {
      appkey = navigator.userAgent.indexOf('Android') >= 0 ? appkeys.android : appkeys.ios;
      return window.plugins.AdMob.createBannerView({
        publisherId: appkey,
        adSize: window.plugins.AdMob.AD_SIZE.BANNER,
        'bannerAtTop': false
      }, successCallback, failureCallback);
    } else {
      return console.log("Cordova AdMob not found, suppose debug mode");
    }
  };
  document.addEventListener('onReceiveAd', function() {
    return console.log("onReceiveAd");
  });
  document.addEventListener('onFailedToReceiveAd', function(evt, err) {
    return console.log("onFailedToReceiveAd", evt, err);
  });
  document.addEventListener('onPresentAd', function() {
    return console.log("onPresentAd");
  });
  document.addEventListener('onDismissAd', function() {
    return console.log("onDismissAd");
  });
  document.addEventListener('onLeaveToAd', function() {
    return console.log("onLeaveToAd");
  });
  return {
    start: startAd
  };
});

var BAIO_AUTH_EVENTS, baioAuth;

baioAuth = angular.module("baio-ng-cordova-auth", ["ngResource", "angular-data.DSCacheFactory"]);

BAIO_AUTH_EVENTS = {
  forbidden: 'baioAuth:FORBIDDEN',
  loginSuccess: 'baioAuth:LOGIN_SUCCESS',
  loginFailed: 'baioAuth:LOGIN_FAILED',
  logout: 'baioAuth:LOGOUT',
  redirectEnded: 'baioAuth:REDIRECT_ENDED'
};

baioAuth.constant('BAIO_AUTH_EVENTS', BAIO_AUTH_EVENTS);

baioAuth.factory("tokenFactory", function(DSCacheFactory) {
  var authCache;
  authCache = DSCacheFactory('authCache', {
    maxAge: 1000 * 60 * 60 * 24 * 2,
    deleteOnExpire: 'aggressive',
    storageMode: 'localStorage'
  });
  return {
    get: function() {
      return authCache.get("/token");
    },
    set: function(token) {
      return authCache.put("/token", token);
    },
    reset: function() {
      return authCache.remove("/token");
    }
  };
});

baioAuth.factory("baioAuthInterceptor", function(tokenFactory, $rootScope, $q) {
  return {
    request: function(config) {
      var token;
      token = tokenFactory.get("/token");
      if (token) {
        config.headers.authorization = "Bearer " + token;
      }
      return config;
    },
    responseError: function(response) {
      console.log("responseError", response);
      if (response.status === 401) {
        $rootScope.$broadcast(BAIO_AUTH_EVENTS.forbidden, response);
      }
      return $q.reject(response);
    }
  };
});

baioAuth.config(function($httpProvider) {
  return $httpProvider.interceptors.push("baioAuthInterceptor");
});

baioAuth.provider("auth", function() {
  this.$get = function($q, $resource, tokenFactory, $rootScope) {
    var _url, resource;
    _url = this.url;
    resource = $resource(_url + "getProfile");
    return {
      profile: null,
      setToken: function(token) {
        return tokenFactory.set(token);
      },
      login: function() {
        var err, loaded;
        loaded = $q.defer();
        if (!_url) {
          $rootScope.$broadcast(BAIO_AUTH_EVENTS.loginSuccess);
          loaded.resolve();
        } else if (this.profile) {
          loaded.resolve(this.profile);
        } else if (tokenFactory.get()) {
          resource.get((function(_this) {
            return function(res) {
              _this.profile = res;
              loaded.resolve(res);
              return $rootScope.$broadcast(BAIO_AUTH_EVENTS.loginSuccess, res);
            };
          })(this), function(err) {
            $rootScope.$broadcast(BAIO_AUTH_EVENTS.loginFailed, err);
            return loaded.reject(err);
          });
        } else {
          err = "Token not found";
          $rootScope.$broadcast(BAIO_AUTH_EVENTS.loginFailed, err);
          loaded.reject(err);
        }
        return loaded.promise;
      },
      logon: function(token) {
        this.setToken(token);
        return this.login();
      },
      logout: function() {
        this.profile = null;
        tokenFactory.reset();
        return $rootScope.$broadcast(BAIO_AUTH_EVENTS.logout);
      },
      openAuthService: function(lang) {
        var ref, url;
        if (!_url) {
          console.log("There is no url defined for auth server, consider test mode, exit from openAuthAService");
          return;
        }
        url = _url;
        if (lang) {
          url += "?lang=" + lang;
        }
        window.location = url;
        if (window.cordova) {
          ref = window.open(_url, '_blank', 'location=no,toolbar=no');
          return ref.addEventListener('loadstart', function(e) {
            var token;
            url = e.url;
            token = /\?token=(.+)$/.exec(url);
            if (token) {
              console.log("token is " + token[1]);
              ref.close();
              return loginSuccess(token[1], tokenFactory, $rootScope);
            }
          });
        } else {
          return window.location = _url;
        }
      }
    };
  };
  this.setUrl = function(url) {
    return this.url = url;
  };
  return this;
});

"use strict";
var __onCordovaPushNotifications;

__onCordovaPushNotifications = {
  onBroadcastRegistered: null,
  onBroadcastError: null,
  onBroadcastMessage: null,
  channelHandler: function(e) {
    return this.onBroadcastRegistered(e.uri, "wp8");
  },
  successHandler: function(e) {
    return console.log("GSM  success handler", e);
  },
  errorHandler: function(err) {
    console.log("errorHandler", err);
    return this.onBroadcastError(err);
  },
  tokenHandler: function(token) {
    console.log("APN  token handler", token);
    return this.onBroadcastRegistered(token, "ios");
  },
  onNotificationWP8: function(e) {
    return this.onBroadcastMessage(e.message);
  },
  onNotificationGCM: function(e) {
    console.log("onNotificationGCM", e);
    switch (e.event) {
      case 'registered':
        if (e.regid.length > 0) {
          this.onBroadcastRegistered(e.regid, "android");
        } else {
          this.onBroadcastError("GSM registration failed");
        }
        break;
      case 'message':
        this.onBroadcastMessage(e.message);
        break;
      case 'error':
        this.onBroadcastError("An unknown GCM error");
        break;
      default:
        this.onBroadcastError("An unknown GCM event has occurred");
    }
    return {
      onNotificationAPN: function(e) {
        var badgeErrorHandler, badgeSuccessHandler, snd;
        if (e.alert) {
          this.onBroadcastMessage(e.message);
        }
        if (e.sound) {
          snd = new Media(e.sound);
          snd.play();
        }
        if (e.badge) {
          badgeSuccessHandler = function() {
            return console.log("badgeSuccessHandler");
          };
          badgeErrorHandler = function() {
            return console.log("badgeErrorHandler");
          };
          return window.plugins.pushNotification.setApplicationIconBadgeNumber(badgeSuccessHandler, badgeErrorHandler, e.badge);
        }
      }
    };
  }
};

baioNgCordova.factory("cordovaPushNotifications", function($rootScope) {
  return {
    register: function(appKey) {
      var pushNotification;
      __onCordovaPushNotifications.onBroadcastRegistered = function(token, platform) {
        return $rootScope.$broadcast("device::push::registered", {
          token: token,
          platform: platform
        });
      };
      __onCordovaPushNotifications.onBroadcastError = function(msg) {
        var err;
        console.log("broadcastError", msg);
        err = typeof msg === "string" ? new Error(msg) : msg;
        return $rootScope.$broadcast("device::push::error", err);
      };
      __onCordovaPushNotifications.onBroadcastMessage = function(msg) {
        return $rootScope.$broadcast("device::push::message", msg);
      };
      if (!window.cordova) {
        return __onCordovaPushNotifications.onBroadcastRegistered(null, "browser");
      } else {
        pushNotification = window.plugins.pushNotification;
        if (ionic.Platform.isAndroid()) {
          return pushNotification.register(__onCordovaPushNotifications.successHandler, __onCordovaPushNotifications.errorHandler, {
            "senderID": appKey.android,
            "ecb": "__onCordovaPushNotifications.onNotificationGCM"
          });
        } else if (ionic.Platform.isIOS()) {
          return pushNotification.register(__onCordovaPushNotifications.tokenHandler, __onCordovaPushNotifications.errorHandler, {
            badge: "true",
            sound: "true",
            alert: "true",
            ecb: "__onCordovaPushNotifications.onNotificationAPN"
          });
        } else if (ionic.Platform.isWindowsPhone()) {
          return pushNotification.register(__onCordovaPushNotifications.channelHandler, __onCordovaPushNotifications.errorHandler, {
            "channelName": "ride-better-channel",
            "ecb": "__onCordovaPushNotifications.onNotificationWP8",
            "uccb": "__onCordovaPushNotifications.channelHandler",
            "errcb": "__onCordovaPushNotifications.errorHandler"
          });
        } else {
          throw "Unknown cordova platform";
        }
      }
    }
  };
});

app.factory("baseMessages", function(messages, faq, report, transfer) {
  var getBase, getBaseBoardName, isThreadOfType;
  isThreadOfType = function(thread, type) {
    if (typeof thread === "string") {
      return thread === type;
    } else {
      return thread.tags.indexOf(type) !== -1;
    }
  };
  getBase = function(thread) {
    if (isThreadOfType(thread, "faq")) {
      return faq;
    } else if (isThreadOfType(thread, "message")) {
      return messages;
    } else if (isThreadOfType(thread, "transfer")) {
      return transfer;
    } else if (isThreadOfType(thread, "report")) {
      return report;
    }
  };
  getBaseBoardName = function(thread) {
    if (isThreadOfType(thread, "faq")) {
      return "faq";
    } else if (isThreadOfType(thread, "message")) {
      return "message";
    } else if (isThreadOfType(thread, "transfer")) {
      return "transfer";
    } else if (isThreadOfType(thread, "report")) {
      return "report";
    }
  };
  return {
    opts: {
      thread: {
        getCreateBoardName: getBaseBoardName,
        scope: {
          isThreadOfType: isThreadOfType,
          msgForm: messages.opts.thread.scope,
          faqMsgForm: faq.opts.thread.scope,
          transferForm: transfer.opts.thread.scope,
          reportForm: report.opts.thread.scope,
          simpleMsgForm: messages.opts.reply.scope
        },
        modalTemplate: function(thread) {
          return getBase(thread).opts.thread.modalTemplate;
        },
        map2send: function(thread) {
          return getBase(thread).opts.thread.map2send();
        },
        item2scope: function(thread) {
          return getBase(thread).opts.thread.item2scope(thread);
        },
        validate: function(thread) {
          return getBase(thread).opts.thread.validate();
        },
        reset: function(thread) {
          return getBase(thread).opts.thread.reset();
        }
      },
      reply: faq.opts.reply
    }
  };
});

app.factory("faq", function(resources, sendSimpleMsgFormScope) {
  return {
    opts: {
      thread: {
        scope: sendSimpleMsgFormScope.scope,
        modalTemplate: "modals/sendSimpleMsgForm.html",
        map2send: function() {
          return sendSimpleMsgFormScope.scope.getSendThreadData();
        },
        item2scope: function(item) {
          return sendSimpleMsgFormScope.scope.data.message = item.data.text;
        },
        validate: function() {
          return sendSimpleMsgFormScope.scope.validate();
        },
        reset: function() {
          return sendSimpleMsgFormScope.scope.reset();
        }
      },
      reply: {
        scope: sendSimpleMsgFormScope.scope,
        modalTemplate: "modals/sendSimpleMsgForm.html",
        map2send: function() {
          return sendSimpleMsgFormScope.scope.getSendThreadData();
        },
        item2scope: function(item) {
          return sendSimpleMsgFormScope.scope.data.message = item.data.text;
        },
        validate: function() {
          return sendSimpleMsgFormScope.scope.validate();
        },
        reset: function() {
          return sendSimpleMsgFormScope.scope.reset();
        }
      }
    }
  };
});

app.factory("messages", function(resources, sendMsgFormScope, sendSimpleMsgFormScope) {
  return {
    opts: {
      thread: {
        scope: sendMsgFormScope.scope,
        modalTemplate: "modals/sendMsgForm.html",
        map2send: function() {
          return sendMsgFormScope.scope.getSendThreadData();
        },
        item2scope: function(item) {
          var ref;
          sendMsgFormScope.scope.data.message = item.data.text;
          if ((ref = item.data.meta) != null ? ref.priority : void 0) {
            sendMsgFormScope.scope.data.priority = sendMsgFormScope.scope.prioritiesList.filter(function(f) {
              return f.code === item.data.meta.priority;
            })[0];
          }
          if (item.data.img) {
            return sendMsgFormScope.scope.data.photo.src = item.data.img;
          }
        },
        validate: function() {
          return sendMsgFormScope.scope.validate();
        },
        reset: function() {
          return sendMsgFormScope.scope.reset();
        }
      },
      reply: {
        scope: sendSimpleMsgFormScope.scope,
        modalTemplate: "modals/sendSimpleMsgForm.html",
        map2send: function() {
          return sendSimpleMsgFormScope.scope.getSendThreadData();
        },
        item2scope: function(item) {
          return sendSimpleMsgFormScope.scope.data.message = item.data.text;
        },
        validate: function() {
          return sendSimpleMsgFormScope.scope.validate();
        },
        reset: function() {
          return sendSimpleMsgFormScope.scope.reset();
        }
      }
    }
  };
});

app.factory("report", function(sendSimpleMsgFormScope) {
  return {
    opts: {
      thread: {
        scope: sendSimpleMsgFormScope.scope,
        modalTemplate: "modals/sendSimpleMsgForm.html",
        map2send: function() {
          return sendSimpleMsgFormScope.scope.getSendThreadData();
        },
        item2scope: function(item) {
          sendSimpleMsgFormScope.scope.data.message = item.data.text;
          return sendSimpleMsgFormScope.scope.data.meta = item.data.meta;
        },
        validate: function() {
          return sendSimpleMsgFormScope.scope.validate();
        },
        reset: function() {
          return sendSimpleMsgFormScope.scope.reset();
        }
      },
      reply: {
        scope: sendSimpleMsgFormScope.scope,
        modalTemplate: "modals/sendSimpleMsgForm.html",
        map2send: function() {
          return sendSimpleMsgFormScope.scope.getSendThreadData();
        },
        item2scope: function(item) {
          return sendSimpleMsgFormScope.scope.data.message = item.data.text;
        },
        validate: function() {
          return sendSimpleMsgFormScope.scope.validate();
        },
        reset: function() {
          return sendSimpleMsgFormScope.scope.reset();
        }
      }
    }
  };
});

app.factory("transfer", function(resources, transferFormScope, sendSimpleMsgFormScope) {
  return {
    opts: {
      thread: {
        scope: transferFormScope.scope,
        modalTemplate: "modals/transferMsgForm.html",
        map2send: function() {
          return transferFormScope.scope.getSendThreadData();
        },
        item2scope: function(item) {
          var scope;
          scope = transferFormScope.scope;
          scope.data.message = item.data.text;
          scope.data.from = item.data.meta.from;
          if (item.data.meta.date) {
            scope.data.date = moment(item.data.meta.date, "X").startOf("d").toDate();
            scope.data.time = scope.hoursList[moment(item.data.meta.date, "X").hours() - 1];
          }
          scope.data.type = scope.typesList.filter(function(f) {
            return f.code === item.data.meta.type;
          })[0];
          scope.data.transport = scope.transportTypesList.filter(function(f) {
            return f.code === item.data.meta.transport;
          })[0];
          scope.data.price = item.data.meta.price;
          return scope.data.phone = item.data.meta.phone;
        },
        validate: function(data) {
          return transferFormScope.scope.validate();
        },
        reset: function() {
          return transferFormScope.scope.reset();
        }
      },
      reply: {
        scope: sendSimpleMsgFormScope.scope,
        modalTemplate: "modals/sendSimpleMsgForm.html",
        map2send: function() {
          return sendSimpleMsgFormScope.scope.getSendThreadData();
        },
        item2scope: function(item, data) {
          return sendSimpleMsgFormScope.scope.data.message = item.data.text;
        },
        validate: function(data) {
          return sendSimpleMsgFormScope.scope.validate();
        },
        reset: function() {
          return sendSimpleMsgFormScope.scope.reset();
        }
      }
    }
  };
});

app.constant("strings_en", {
  "main": "Main",
  "info": "Info",
  "prices": "Prices",
  "faq": "FAQ",
  "transfer": "Transfer",
  "user": "User",
  "add": "Add Stuff",
  "send": "Send",
  "cancel": "Cancel",
  "add_message": "Add Message",
  "add_new": "Add New",
  "min": "Min",
  "max": "Max",
  "report": "Report",
  "closed": "Closed",
  "very_little_powder": "very little powder",
  "not_enough_powder": "not enough powder",
  "enough_powder": "enough powder",
  "much_powder": "much powder",
  "lots_of_powder": "lots of powder",
  "snow_not_fall": "snow does not fall out",
  "not_much_snow": "not much snow fell",
  "enough_snow": "dropped enough snow",
  "much_snow": "much snow fell",
  "lots_snow": "lots of snow fell",
  "very_few_people": "very few people",
  "few_people": "few people",
  "enough_people": "enough people",
  "many_people": "many people",
  "too_many people": "too many people",
  "crowd_q": "Crowd ?",
  "snowing_q": "Snowing ?",
  "powder_q": "Powder on pistes ?",
  "name": "Name",
  "home": "Home",
  "language": "Language",
  "units": "Units",
  "reset": "Reset",
  "login": "Login",
  "logout": "Logout",
  "my_info": "My Info",
  "profile": "Me",
  "authorization": "Authorization",
  "search": "Search",
  "mi": "mi",
  "in": "in",
  "km": "km",
  "cm": "cm",
  "reason": "Rason",
  "supposed_open_date": "Supposed open date",
  "europe": "Europe",
  "united_kingdom": "United Kingdom",
  "united_states": "United States",
  "english": "English",
  "russian": "Russian",
  "unknown": "Unknown",
  "day_off": "Day off",
  "off_season": "Off season",
  "some_error": "Some error occurred, please try again later",
  "error": "Error",
  "alert": "Alert",
  "dd_mm_yyyy": "dd.mm.yyyy",
  "rain": "rain",
  "sleet": "sleet",
  "hail": "hail",
  "please_input_data": "Please input some data to send",
  "date_is_wrong": "Date in wrong format",
  "talk": "Talk",
  "send_message": "Send Message",
  "nessage": "Message",
  "user_not_logined": "User not logined",
  "no_more_images": "No more images, try again later",
  "today": "Today",
  "housing": "Housing",
  "trip": "Trip",
  "food": "Food",
  "shops": "Shops",
  "services": "Services",
  "snowfall_history": "Snowfall History",
  "days": "Days",
  "cumulative": "Cumulative",
  "fall": "Fall",
  "resort": "Resort",
  "back_home": "Back Home",
  "resort_info": "Resort Info",
  "install_native_q": "Would you like to install native app ?",
  "sure": "Sure",
  "not_now": "Not Now",
  "ask_question": "Ask Question",
  "replies": "Replies",
  "reply": "Reply",
  "remove": "Remove",
  "edit": "Edit",
  "delete_q": "After delete, item couldn't be restored. Delete?",
  "input_text": "Please input some text",
  "new_settings_reload": "New settings will be activated only after reload",
  "reload": "Reload",
  "car": "Car",
  "micro_bus": "Micro Bus",
  "bus": "Bus",
  "from_town": "From town",
  "from": "From",
  "date": "Date",
  "hours": "Hours",
  "transport_type": "Transport Type",
  "price": "Price",
  "phone": "Phone",
  "phone_number": "Phone number",
  "create_transfer": "Create transfer",
  "create": "Create",
  "from_town_required": "From town is required",
  "success": "Success",
  "fail": "Fail",
  "add_photo": "Please add some photo",
  "add_title": "Please add some title",
  "choose_tag": "Please choose some tag",
  "lift_prices": "Lift Prices",
  "rent_prices": "Rent Prices",
  "food_prices": "Food Prices",
  "service_prices": "Service Prices",
  "title": "Title",
  "tag": "Tag",
  "attach_photo": "Attach photo",
  "take_photo": "Take photo",
  "messages": "Messages",
  "message": "Message",
  "current": "Current",
  "favorites": "Favorites",
  "all": "All",
  "forecast": "Forecast",
  "snowfall": "Snowfall",
  "question": "Question",
  "choose_message": "Choose message",
  "reports": "Reports",
  "add_report": "Add report",
  "add_transfer": "Add transfer",
  "priority": "Priority",
  "normal": "Normal",
  "important": "Important",
  "contacts": "Contacts",
  "webcams": "Webcams",
  "maps": "Maps",
  "remove_photo": "Remove Photo",
  "total_past": "Total for the past days",
  "for_day": "For the day",
  "add_price": "Add Price",
  "yes": "Yes",
  "no": "No",
  "message_required": "Please add some message",
  "photo_required": "Please add some photo",
  "title_required": "Please add some title",
  "tag_required": "Please choose some tag",
  "data_required": "Please input some data to send",
  "confirm_delete": "After delete, item couldn't be restored. Delete?",
  "filter_message": "Filter messages",
  "ok": "OK",
  "show_messages_for": "Show messages for",
  "snofall_hist_favs": "Snowfall for past week",
  "private": "Private",
  "regular": "Regular",
  "taxi": "Taxi",
  "transfer_type": "Transfer type",
  "tranfer_requests": "Transfer Requests",
  "close": "Close",
  "request": "Request",
  "requested": "Requested",
  "rejected": "Rejected",
  "accepted": "Accepted",
  "already_go": "Already Go",
  "unrequest_transfer": "Are you seriosuly refuse to take this transfer ?"
});

app.constant("strings_ru", {
  "main": "Главная",
  "info": "Информация",
  "prices": "Цены",
  "transfer": "Добраться",
  "user": "Пользователь",
  "add": "Добавить",
  "messages": "Cообщения",
  "send": "Отправить",
  "cancel": "Отменить",
  "add_message": "Добавить сообщение",
  "add_new": "Добавить новое",
  "snow": "Снег",
  "min": "Мин",
  "max": "Макс",
  "report": "Отчет",
  "closed": "Закрыто",
  "very_little_powder": "очень мало снега",
  "not_enough_powder": "недостаточно снега",
  "enough_powder": "достаточно снега",
  "much_powder": "много снега",
  "lots_of_powder": "очень много снега",
  "snow_not_fall": "снег не выпадал",
  "not_much_snow": "выпало не много снега",
  "enough_snow": "выпало достаточно снега",
  "much_snow": "выпало много снега",
  "lots_snow": "выпало очень много снега",
  "very_few_people": "очень мало людей",
  "few_people": "мало людей",
  "enough_people": "достаточно людей",
  "many_people": "много людей",
  "too_many people": "очень много людей",
  "crowd_q": "Сколько людей ?",
  "snowing_q": "Снег идет ?",
  "powder_q": "Снег на трассах ?",
  "name": "Имя",
  "home": "Дом",
  "language": "Язык",
  "units": "Единицы",
  "reset": "Сбросить",
  "login": "Войти",
  "logout": "Выйти",
  "my_info": "Профайл",
  "favorites": "Избранное",
  "profile": "Профайл",
  "authorization": "Авторизация",
  "search": "Поиск",
  "mi": "ми",
  "in": "дм",
  "km": "км",
  "cm": "см",
  "reason": "Причина",
  "supposed_open_date": "Предпологаемая дата открытия",
  "europe": "Европа",
  "united_kingdom": "Англия",
  "united_states": "Америка",
  "english": "Английский",
  "russian": "Русский",
  "unknown": "Неизвестно",
  "day_off": "Выходной",
  "off_season": "Сезон закрыт",
  "some_error": "Произошла ошибка, пожайлуста повтарите позднее",
  "error": "Ошибка",
  "alert": "Внимание",
  "dd_mm_yyyy": "дд.мм.гггг",
  "rain": "дождь",
  "sleet": "град",
  "hail": "снег с дождем",
  "please_input_data": "Пожайлуста введите данные",
  "date_is_wrong": "Дата имеет неправильный формат",
  "talk": "Разговор",
  "send_message": "Отправить сообщение",
  "nessage": "Сообщение",
  "user_not_logined": "Пользватель не залогинен",
  "no_more_images": "Нет больше изображений, попробуйте позднее",
  "today": "Сегодня",
  "housing": "Размещение",
  "trip": "Поездка",
  "food": "Питание",
  "shops": "Магазины",
  "services": "Услуги",
  "snowfall_history": "Истоия снегопада",
  "days": "Дни",
  "cumulative": "Суммарно",
  "fall": "Выпало",
  "resort": "Курорт",
  "back_home": "Назад домой",
  "resort_info": "Информация о курорте",
  "install_native_q": "Хотите установить мобильное приложение ?",
  "sure": "Да",
  "not_now": "Не сейчас",
  "faq": "Вопросы",
  "ask_question": "Задать вопрос",
  "replies": "Ответы",
  "reply": "Ответ",
  "remove": "Удалить",
  "edit": "Изменить",
  "delete_q": "После удаления данные не могут быть восстановлены. Продолжить?",
  "input_text": "Пожайлуста введите текст",
  "new_settings_reload": "новые настройки будут установлены после перезагрузки",
  "reload": "Перегрузить",
  "car": "Машина",
  "micro_bus": "Микро автобус",
  "bus": "Автобус",
  "from_town": "Из города",
  "from": "Из",
  "date": "Дата",
  "hours": "Часы",
  "transport_type": "Тип транспорта",
  "price": "Цена",
  "phone": "Телефон",
  "phone_number": "Номер телефона",
  "create_transfer": "Создать трансфер",
  "create": "Создать",
  "from_town_required": "Из Города - необходимо заполнить",
  "fail": "Ошибка",
  "add_photo": "Пожайлуста добавьте фото",
  "add_title": "Пожайлуста добавьте заголовок",
  "choose_tag": "Пожайлуста выберите таг",
  "lift_prices": "Цены на подъемник",
  "rent_prices": "Цены на аренду",
  "food_prices": "Цены на питание",
  "service_prices": "Цены на услуги",
  "title": "Заголовок",
  "tag": "Таг",
  "attach_photo": "Добавить фото",
  "take_photo": "Снять фото",
  "message": "Сообщение",
  "current": "Текущий",
  "all": "Все",
  "forecast": "Погода",
  "snowfall": "Снегопад",
  "question": "Вопрос",
  "choose_message": "Выберитеь сообщение",
  "reports": "Курорты",
  "add_report": "Добавить сообщение",
  "add_transfer": "Добавить трансфер",
  "priority": "Важность",
  "normal": "Обычное",
  "important": "Важное",
  "contacts": "Контакты",
  "webcams": "Камеры",
  "maps": "Карты",
  "remove_photo": "Удалить фото",
  "total_past": "Суммарно за прошедшие дни",
  "for_day": "За день",
  "add_price": "Добавить цену",
  "yes": "Да",
  "no": "Нет",
  "message_required": "Пожайлуста добавьте сообщение",
  "photo_required": "Пожайлуста добавьте фото",
  "title_required": "Пожайлуста добавьте заголовок",
  "tag_required": "Пожайлуста добавьте таг",
  "data_required": "Пожайлуста введите данные",
  "confirm_delete": "После удаления данные не могут быть восстановлены. Продолжить?",
  "filter_message": "Фильтровать сообщения",
  "ok": "OK",
  "show_messages_for": "Показывать сообщения для",
  "snofall_hist_favs": "Количество выпавшего снега за неделю",
  "private": "Частный",
  "regular": "Регулярный",
  "taxi": "Такси",
  "transfer_type": "Тип трансфера",
  "tranfer_requests": "Запрос трансфера",
  "close": "Закрыть",
  "request": "Запрос",
  "requested": "Запрошен",
  "rejected": "Отменен",
  "accepted": "Подтвержден",
  "already_go": "Уже едут",
  "unrequest_transfer": "На самом деле не хочешь ехать ?"
});
