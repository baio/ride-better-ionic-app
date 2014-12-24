app.controller "UserController", ($scope, user, resources) ->

  console.log "User Controller"

  $scope.login = user.login
  $scope.logout = user.logout
  $scope.isLogined = user.isLogined
  $scope.reset = user.reset

  $scope.culturesList = [
    {code : "eu", name : resources.str("Europe")}
    {code : "uk", name : resources.str("United Kingdom")}
    {code : "us", name : resources.str("United States")}
  ]

  $scope.langsList = [
    {code : "en", name : resources.str("English")}
    {code : "ru", name : resources.str("Russian")}
  ]

  $scope.setCulture = user.setCulture
  $scope.setLang = user.setLang

  $scope.user = user.user
  $scope.data = {}

  updScopeData = ->
    $scope.data.culture = $scope.culturesList.filter((f) -> f.code == user.getCulture())[0]
    $scope.data.lang = $scope.langsList.filter((f) -> f.code == user.getLang())[0]
  
  updScopeData()

