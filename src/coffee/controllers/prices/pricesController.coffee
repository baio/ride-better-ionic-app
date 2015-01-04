app.controller "PricesController", ($scope, pricesViewResolved, $ionicSlideBoxDelegate) ->

  console.log "PricesController", pricesViewResolved

  $scope.prices = pricesViewResolved

  $scope.$on '$ionicView.enter', ->
    $timeout (-> $ionicSlideBoxDelegate.update()), 0

