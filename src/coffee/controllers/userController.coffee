app.controller "UserController", ($scope, user) ->

  console.log "User Controller"

  $scope.login = user.login
  $scope.logout = user.logout
  $scope.isLogin = user.isLogin
  $scope.reset = user.reset

  $scope.culturesList = [
    {code : "eu", name : "Europe"}
    {code : "uk", name : "United Kingdom"}
    {code : "us", name : "United States"}
  ]

  $scope.langsList = [
    {code : "en", name : "English"}
    {code : "ru", name : "Russian"}
  ]

  $scope.setCulture = user.setCulture
  $scope.setLang = user.setLang

  $scope.user = user.user
  $scope.data = {}

  updScopeData = ->
    $scope.data.culture = $scope.culturesList.filter((f) -> f.code == user.getCulture())[0]
    $scope.data.lang = $scope.langsList.filter((f) -> f.code == user.getLang())[0]

  $scope.$on "user.reset", ->
    updScopeData()

  updScopeData()
