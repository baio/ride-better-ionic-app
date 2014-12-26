app.controller "MainController", ($scope, homeResolved) ->

  console.log "mainController.coffee:3 >>>",  homeResolved.culture
  $scope.culture = homeResolved.culture



