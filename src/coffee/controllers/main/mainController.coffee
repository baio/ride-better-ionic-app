app.controller "MainController", ($scope, homeResolved) ->

  $scope.culture = homeResolved.culture

  $scope.$on "$ionicView.enter", ->
    $scope.snapshot = homeResolved.snapshot
    $scope.snowfallHistory = homeResolved.snowfallHistory
    $scope.reports = homeResolved.reports
    $scope.latestImportant = homeResolved.latestImportant
