app.factory "user", ($q, cache, spot,  $rootScope, $ionicPopup, res, culture, geoLocator, authio, mapper) ->

  user = {}

  initialize = ->
    $rootScope.res = res
    geoLocator.getPosition()
    _user = cache.get "user"
    _user ?= defaultUser()
    setUser _user
    $rootScope.homeLabel = getHome().label

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
    authio.setData "surf_better", user.settings
    $rootScope.homeLabel = getHome().label

  defaultUser = ->
    profile : null
    settings :
      lang : "en"
      culture : "eu"
      favs : [
          { code : "BR_RJ_RDJ_AR", name : "Arpoador", label : "Arpoador, Rio de Janeiro", isHome : true }
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

  showConfirmAuth = ->
    $ionicPopup.confirm(
      title: res.str.authreqcaption
      template: res.str.authreqtext
    ).then (res) ->
      if res then res else $q.reject()

  initialize : initialize

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
    saveChanges()

  getLang: ->
    user.settings.lang

  setCulture: (c) ->
    culture.setCulture c.code
    user.settings.culture = c.code
    saveChanges()

  getCulture: ->
    user.settings.culture

  login: (confirm) ->
    opts = force : true
    opts.confirm = showConfirmAuth if confirm
    authio.login("facebook", opts).then (res) -> setUser(mapper.mapUser(res))

  logout: ->
    authio.logout()
    user.profile = null
    saveChanges()

  isLogin: -> user.profile

  reset : reset

  user : user

  setUser : setUser



