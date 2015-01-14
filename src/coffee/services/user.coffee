app.factory "user", ($q, cache, $rootScope, $ionicModal, resources, geoLocator,
                     authio, mapper, amMoment, globalization, notifier, spotsDA, mobileDetect, $ionicConfig) ->

  user = {}

  authForm = null
  deferredAuthForm = null

  initialize = ->
    setUser defaultUser()

  setUser = (u) ->
    user.profile = u.profile    
    if u.settings
      user.settings = u.settings
      putLang user.settings.lang
      putCulture user.settings.culture
      putMsgsFilter user.settings.msgsFilter

  saveChangesToCache = ->
    cache.put "user", user

  saveChangesOnline = ->
    if authio.isLogined()
      authio.setData "ride_better", user.settings

  saveChanges = ->
    saveChangesToCache()
    saveChangesOnline()

  defaultUser = ->
    profile : null
    settings :
      lang : "en"
      culture : "eu"
      favs : [
          { id : "1936", title : "Завьялиха", isHome : true }
          { id : "28", title : "Whistler Blackcomb (Garibaldi Lift Co.)" }
        ]
      msgsFilter :
        spots : "all" 
        boards : "message,report,faq,transfer"

  getHome = ->
    user.settings.favs.filter((f) -> f.isHome)[0]

  getUserAsync = ->
    deferred = $q.defer()
    if $rootScope.activated
      deferred.resolve(user)
    else
      $rootScope.$on "app.activated", -> 
        deferred.resolve(user)
    deferred.promise

  reset = ->
    authio.logout()
    cache.clean()
    angular.copy defaultUser(), user
    putLang user.settings.lang
    putCulture user.settings.culture
    saveChanges()

  # Auth form

  $ionicModal.fromTemplateUrl( 'modals/authForm.html',
      animation: "slide-in-up"
      scope : $rootScope
  ).then (form) ->
    authForm = form

  showAuthForm = ->
    deferredAuthForm = $q.defer()
    authForm.show()
    notifier.showLoading()
    authio.preLogin().finally ->
      notifier.hideLoading()
    deferredAuthForm.promise

  $rootScope.$on "modal.hidden", (modal) ->
    if user.profile
      deferredAuthForm.resolve()
    else
      deferredAuthForm.reject()

  $rootScope.authorizeProvider = (provider) ->
    opts = force : true
    notifier.showLoading()
    authio.login(provider, opts).then((res) ->
      setUser mapUser(res)
      saveChangesToCache()
    ).finally ->
      $rootScope.hideAuthForm()
      notifier.hideLoading()

  $rootScope.hideAuthForm = ->
    authForm.hide()

  putLang = (lang) ->
    user.settings.lang = lang
    resources.setLang lang

  putCulture = (c) ->
    user.settings.culture = c

  putMsgsFilter = (filter) ->
    user.settings.msgsFilter = filter

  onHomeChanged = (home) ->
    $rootScope.$broadcast("user::homeChanged", home)

  onPropertyChanged = ->
    $rootScope.$broadcast("user::propertyChanged", user)

  #

  setHome = (spot) ->
    for fav in user.settings.favs
      fav.isHome = false
    spot.isHome = true  
    onHomeChanged spot

  addSpot = (spot) ->
    favs = user.settings.favs
    fav = favs.filter((f) -> f.id == spot.id)[0]
    if !fav
      favs.push spot    
      true
    else
      false

  setLang = (lang) ->
    putLang lang.code
    saveChanges()
    onPropertyChanged()

  setCulture = (c) ->
    putCulture c.code
    saveChanges()
    onPropertyChanged()

  setMsgsFilter = (filter) ->
    putMsgsFilter filter
    saveChanges()
    onPropertyChanged()

  getDefaultNearestSpot = ->
    geoLocator.getPosition()
    .then (geo) ->
      spotsDA.nearest(geo.lat + "," + geo.lon)
    .then (res) ->
      spots = res.map (m) -> id : m.code, title : m.label
      console.log "user.coffee:153 >>>", spots
      for spot in spots
        addSpot spot
      res

  getDefaultLagAndCulture = ->
    globalization.getLangAndCulture().then (r) =>
      putLang r.lang
      putCulture r.culture
      null

  setFisrtLaunchComplete = ->
    cache.put "firstLaunchComplete", true

  isFirstLaunch = ->
    !(cache.get("firstLaunchComplete") == true)

  mapUser = (user) ->
    res = profile : user.profile
    if user.data?.ride_better
      res.settings = user.data.ride_better
    res

  getCahchedUser = ->
    cache.get "user"

  setUserFromCache = ->
    cachedUser = getCahchedUser()
    if cachedUser
      setUser cachedUser
    notifier.message "user_not_logined"

  activate = ->
    
    notifier.showLoading()
    initialize()

    if isFirstLaunch()
      console.log ">>>user.coffee:146", "This is first launch"
      setFisrtLaunchComplete()
      promise = $q.all([getDefaultNearestSpot(), getDefaultLagAndCulture()]).then ->
        if user.settings.lang == "en"
          user.settings.favs[0].isHome = false
          user.settings.favs[1].isHome = true        
        saveChangesToCache()
    else
      if !authio.isLogined() and user.profile
        console.log ">>>user.coffee:153", "Something wrong, user not logined but profile exists! reset profile"
        user.profile = null
      cachedUser = getCahchedUser()
      if !cachedUser 
        console.log ">>>user.coffee:16 3", "This is not first entance, but user doesn't exist in cache"
        promise = $q.when()
      else
        if authio.isLogined() and !cachedUser.profile
          console.log ">>>user.coffee:16 3", "Something wrong, user is logined but profile not exists! logout"
          authio.logout()
        if cachedUser.profile
          promise = authio.login(cachedUser.profile.provider, force : false)
          .then (res) ->
              setUser mapUser res
              saveChangesToCache()
          .catch ->
            if cachedUser and cachedUser.profile
              cachedUser.profile = null
              saveChangesToCache()
            setUserFromCache()
        else
          setUserFromCache()
          promise = $q.when()

    promise.finally (res) ->
      $rootScope.activated = true
      $rootScope.$broadcast("app.activated")      
      notifier.hideLoading()

    promise


  notifyNative = ->
    os = mobileDetect.mobileOS()
    if os
      notifier.notifyNative(os)
      .then (res) ->
        if res
          switch os
            when "ios" 
              ref = "https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/app/945742403"
            when "android"
              ref = "https://play.google.com/store/apps/details?id=com.ionicframework.ridebetter"
            when "wp"
              ref = "http://www.windowsphone.com/s?appid=8e18205b-b849-4d41-922b-b5ad2929dc93"
          window.open ref, "_blank"
        res
    else
      $q.when()

  activate: ->
    notifyNative().then ->
      activate()

  getUserAsync: getUserAsync

  getHome: getHome

  setHome: (spot) ->
    setHome(spot)
    saveChanges()

  addSpot: (spot)->
    addSpot(spot)
    saveChanges()

  removeSpot: (spot) ->
    favs = user.settings.favs
    fav = favs.filter((f) -> f.id == spot.id)[0]
    if fav
      favs.splice favs.indexOf(fav), 1
      if fav.isHome 
        favs[0].isHome = true
        onHomeChanged favs[0]
      saveChanges()

  setLang: setLang

  setMsgsFilter : setMsgsFilter

  getLang: ->
    user.settings.lang

  setCulture: setCulture

  getCulture: ->
    user.settings.culture

  login: ->
    if !authio.isLogined()
      showAuthForm()
    else
      $q.when()

  logout: ->
    authio.logout()
    user.profile = null
    saveChanges()

  isLogined: -> authio.isLogined()

  reset : reset

  user : user

  setUser : setUser

  getKey: -> 
    user.profile.provider + "_" + user.profile.id if user?.profile

  isUser: (ur) -> 
    ur.key == @getKey()


