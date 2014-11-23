app.factory "user", ($q, cache, $rootScope, $ionicModal, res, culture, geoLocator, authio, mapper, amMoment, globalization, notifier, spotsDA) ->

  user = {}
  authForm = null
  deferredAuthForm = null

  initialize = ->
    $rootScope.culture = culture
    _user = cache.get "user"
    _user ?= defaultUser()
    setUser _user
    $rootScope.homeLabel = getHome().label

  setUser = (u, save) ->
    user.profile = u.profile
    if u.settings
      user.settings = u.settings
      putLang user.settings.lang
      putCulture user.settings.culture
    $rootScope.homeLabel = getHome().label
    if save
      saveChanges()
    $rootScope.$broadcast "user.changed"

  saveChanges = ->
    cache.put "user", user
    authio.setData "ride_better", user.settings
    $rootScope.homeLabel = getHome().label

  defaultUser = ->
    profile : null
    settings :
      lang : "en"
      culture : "eu"
      favs : [
          { code : "1936", label : "Завьялиха (Zavyalikha)", isHome : true }
        ]

  getHome = -> user.settings.favs.filter((f) -> f.isHome)[0]

  reset = ->
    cache.clean()
    angular.copy defaultUser(), user
    $rootScope.homeLabel = getHome().label
    putLang user.settings.lang
    putCulture user.settings.culture
    saveChanges()
    $rootScope.$broadcast "user.changed"

  # Auth form

  $ionicModal.fromTemplateUrl( 'modals/authForm.html',
      animation: "slide-in-up"
      scope : $rootScope
  ).then (form) ->
    authForm = form

  showAuthForm = ->
    deferredAuthForm = $q.defer()
    authio.preLogin()
    authForm.show()
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
      setUser mapper.mapUser(res), true
    ).finally ->
      $rootScope.hideAuthForm()
      notifier.hideLoading()

  $rootScope.hideAuthForm = ->
    authForm.hide()

  putLang = (lang) ->
    res.setLang lang
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
    saveChanges()

  addSpot = (spot) ->
    favs = user.settings.favs
    fav = favs.filter((f) -> f.code == spot.code)[0]
    if !fav
      favs.push spot
      saveChanges()


  setLang = (lang) ->
    putLang lang.code
    saveChanges()

  setCulture = (c) ->
    putCulture c.code
    saveChanges()

  getDefaultNearestSpot = ->
    geoLocator.getPosition()
    .then (geo) ->
      spotsDA.nearest(geo.lat + "," + geo.lon).then (spot) ->
        addSpot spot
        setHome spot
      null

  getDefaultLagAndCulture = ->
    globalization.getLangAndCulture().then (r) =>
      setLang code : r.lang
      setCulture code : r.culture
      null

  activate: ->
    notifier.showLoading()
    initialize()
    firstLaunch = cache.get "firstLaunch"
    if !firstLaunch
      cache.put "firstLaunch", true
      promise = $q.all([getDefaultNearestSpot(), getDefaultLagAndCulture()])
    else
      if user.profile
        _this = @
        promise = authio.login(user.profile.provider, force : false).then (res) ->
          setUser mapper.mapUser(res), true
        , (err) ->
          _this.logout()
      else
        promise = $q.when()
    promise.finally ->
      notifier.hideLoading()
    promise

  getHome: getHome
  setHome: setHome
  addSpot: addSpot

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
    if !@isLogin()
      showAuthForm()
    else
      $q.when()

  logout: ->
    authio.logout()
    user.profile = null
    saveChanges()

  isLogin: -> user.profile

  reset : reset

  user : user

  setUser : setUser



