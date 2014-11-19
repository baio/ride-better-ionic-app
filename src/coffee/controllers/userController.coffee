app.controller "UserController", ($scope, user, res) ->

  console.log "User Controller"

  $scope.login = user.login
  $scope.logout = user.logout
  $scope.isLogin = user.isLogin
  $scope.reset = user.reset

  $scope.culturesList = [
    {code : "eu", name : res.str("Europe")}
    {code : "uk", name : res.str("United Kingdom")}
    {code : "us", name : res.str("United States")}
  ]

  $scope.langsList = [
    {code : "en", name : res.str("English")}
    {code : "ru", name : res.str("Russian")}
  ]

  $scope.setCulture = user.setCulture
  $scope.setLang = user.setLang

  $scope.user = user.user
  $scope.data = {}

  updScopeData = ->
    $scope.data.culture = $scope.culturesList.filter((f) -> f.code == user.getCulture())[0]
    $scope.data.lang = $scope.langsList.filter((f) -> f.code == user.getLang())[0]

  if $scope.$root.activated
    updScopeData()

  $scope.$on "user.changed", ->
    updScopeData()

  $scope.$on "app.activated", ->
    updScopeData()
