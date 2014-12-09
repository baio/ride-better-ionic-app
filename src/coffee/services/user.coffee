app.factory "user", ($q, cache, $rootScope, $ionicModal, resources, culture, geoLocator,
                     authio, mapper, amMoment, globalization, notifier, spotsDA) ->

  user = {}
  authForm = null
  deferredAuthForm = null

  initialize = ->
    setUser defaultUser()
    $rootScope.culture = culture
    $rootScope.homeLabel = getHome().label

  setUser = (u) ->
    user.profile = u.profile
    if u.settings
      user.settings = u.settings
      putLang user.settings.lang
      putCulture user.settings.culture
    $rootScope.homeLabel = getHome().label

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
          { code : "1936", label : "Завьялиха (Zavyalikha)", isHome : true }
        ]

  getHome = ->
    user.settings.favs.filter((f) -> f.isHome)[0]

  reset = ->
    authio.logout()
    cache.clean()
    angular.copy defaultUser(), user
    $rootScope.homeLabel = getHome().label
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
    resources.setLang lang
    user.settings.lang = lang
    amMoment.changeLocale lang


  putCulture = (c) ->
    culture.setCulture c
    user.settings.culture = c

  #

  setHome = (spot) ->
    for fav in user.settings.favs
      fav.isHome = false
    spot.isHome = true
    $rootScope.homeLabel = getHome().label

  addSpot = (spot) ->
    favs = user.settings.favs
    fav = favs.filter((f) -> f.code == spot.code)[0]
    if !fav
      favs.push spot

  setLang = (lang) ->
    putLang lang.code
    saveChanges()

  setCulture = (c) ->
    putCulture c.code
    saveChanges()

  getDefaultNearestSpot = ->
    geoLocator.getPosition()
    .then (geo) ->
      spotsDA.nearest(geo.lat + "," + geo.lon)
    .then (spot) ->
      addSpot spot
      setHome spot

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
    notifier.message "User not logined"


  activate: ->
    notifier.showLoading()
    initialize()

    if isFirstLaunch()
      console.log ">>>user.coffee:146", "This is first launch"
      setFisrtLaunchComplete()
      promise = $q.all([getDefaultNearestSpot(), getDefaultLagAndCulture()]).then ->
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
      notifier.hideLoading()

    promise

  getHome: getHome

  setHome: (spot) ->
    setHome(spot)
    saveChanges()

  addSpot: (spot)->
    addSpot(spot)
    saveChanges()

  removeSpot: (spot) ->
    favs = user.settings.favs
    fav = favs.filter((f) -> f.code == spot.code)[0]
    if fav
      favs.splice favs.indexOf(fav), 1
      if fav.isHome then favs[0].isHome = true
      saveChanges()

  setLang: setLang

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



