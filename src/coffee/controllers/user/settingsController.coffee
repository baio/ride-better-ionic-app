app.controller "SettingsController", ($scope, user, resources, $window, notifier) ->

  console.log "User Controller"

  $scope.login = user.login
  $scope.logout = user.logout
  $scope.isLogined = user.isLogined
  $scope.homeLabel = user.getHome().label
  $scope.isPropertyChanged = false
  $scope.reset = ->
    user.reset()
    $scope.reload()

  $scope.reload = ->
    $window.location.reload(true)

  $scope.culturesList = [
    {code : "eu", name : resources.str("europe")}
    {code : "uk", name : resources.str("united_kingdom")}
    {code : "us", name : resources.str("united_states")}
  ]

  $scope.langsList = [
    {code : "en", name : resources.str("english")}
    {code : "ru", name : resources.str("russian")}
  ]

  $scope.setCulture = user.setCulture
  $scope.setLang = user.setLang

  $scope.user = user.user
  $scope.home = user.getHome()
  $scope.data = {}

  updScopeData = ->
    $scope.data.culture = $scope.culturesList.filter((f) -> f.code == user.getCulture())[0]
    $scope.data.lang = $scope.langsList.filter((f) -> f.code == user.getLang())[0]
  
  updScopeData()

  $scope.$on "user::propertyChanged", (obj, user) ->
    if user.settings
      $scope.isPropertyChanged = true
      $scope.$root.state.culture = 
        lang : user.settings.lang
        units : user.settings.culture
        code : user.settings.lang + "-" + user.settings.culture
      notifier.message("new_settings_reload")
