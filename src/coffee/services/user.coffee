app.factory "user", ($q, cache, $rootScope, $ionicModal, res, culture, geoLocator, authio, mapper, amMoment, globalization) ->

  user = {}
  authForm = null
  deferredAuthForm = null

  initialize = ->
    $rootScope.culture = culture
    geoLocator.getPosition()
    _user = cache.get "user"
    _user ?= defaultUser()
    setUser _user
    
    $rootScope.homeLabel = getHome().label
    amMoment.changeLocale _user.settings.lang

  setUser = (u, save) ->
    user.profile = u.profile
    if u.settings
      user.settings = u.settings
      res.setLang user.settings.lang
      culture.setCulture user.settings.culture
    $rootScope.homeLabel = getHome().label
    if save
      saveChanges()

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
    res.setLang user.settings.lang
    culture.setCulture user.settings.culture
    saveChanges()
    $rootScope.$broadcast "user.reset"

  # Auth form

  $ionicModal.fromTemplateUrl( 'modals/authForm.html',
      animation: "slide-in-up"
      scope : $rootScope
  ).then (form) ->
    authForm = form

  showAuthForm = ->
    deferredAuthForm = $q.defer()
    authForm.show()
    deferredAuthForm.promise

  $rootScope.$on "modal.hidden", (modal) ->
    if user.profile
      deferredAuthForm.resolve()
    else
      deferredAuthForm.reject()

  $rootScope.authorizeProvider = (provider) ->
    opts = force : true
    authio.login(provider, opts).then (res) ->
      setUser mapper.mapUser(res)
      $rootScope.hideAuthForm()

  $rootScope.hideAuthForm = ->
    authForm.hide()

  #

  initialize : initialize

  activate: ->
    firstLaunch = false #cache.get "firstLaunch"
    if !firstLaunch
      cache.put "firstLaunch", true
      globalization.getLangAndCulture().then (r) =>
        @setLang code : r.lang
        @setCulture code : r.culture

  getHome: getHome

  setHome: (spot) ->
    for fav in user.settings.favs
      fav.isHome = false
    spot.isHome = true
    saveChanges()

  addSpot: (spot) ->
    favs = user.settings.favs
    fav = favs.filter((f) -> f.code == spot.code)[0]
    if !fav
      favs.push spot
      saveChanges()

  removeSpot: (spot) ->
    favs = user.settings.favs
    fav = favs.filter((f) -> f.code == spot.code)[0]
    if fav
      favs.splice favs.indexOf(fav), 1
      if fav.isHome then favs[0].isHome = true
      saveChanges()

  setLang: (lang) ->
    res.setLang lang.code
    user.settings.lang = lang.code
    amMoment.changeLocale lang.code
    saveChanges()

  getLang: ->
    user.settings.lang

  setCulture: (c) ->
    culture.setCulture c.code
    user.settings.culture = c.code
    saveChanges()

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



