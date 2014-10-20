app.controller "UserController", ($scope, user, res, reports) ->

  console.log "User Controller"

  $scope.login = user.login
  $scope.logout = user.logout
  $scope.isLogin = user.isLogin
  $scope.reset = user.reset

  $scope.culturesList = [
    {code : "eu", name : res.str.eu},
    {code : "uk", name : res.str.uk},
    {code : "us", name : res.str.us}]

  $scope.langsList = [
    {code : "en", name : res.str.langen},
    {code : "pt", name : res.str.langpt},
    {code : "fr", name : res.str.langfr},
    {code : "es", name : res.str.langes},
  ]

  $scope.setCulture = user.setCulture
  $scope.setLang = user.setLang

  $scope.user = user.user
  $scope.data = {}

  $scope.sendClosed = ->
    reports.send user.home(), closed : true

  updScopeData = ->
    $scope.data.culture = $scope.culturesList.filter((f) -> f.code == user.getCulture())[0]
    $scope.data.lang = $scope.langsList.filter((f) -> f.code == user.getLang())[0]

  $scope.$on "user.reset", ->
    updScopeData()

  updScopeData()
