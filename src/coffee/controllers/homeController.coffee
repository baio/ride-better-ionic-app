app.controller "HomeController", ($scope, $ionicModal, snapshot, reports, user, res) ->

  console.log "Home Controller"

  setSnapshot = (serviceData) ->
    if serviceData
      $scope.report = serviceData.report
      $scope.forecast =  serviceData.forecast

  home = user.getHome()

  if home
    snapshot.get(home.code).then setSnapshot

  $scope.$on "user.changed", ->
    snapshot.get(user.getHome().code).then setSnapshot




