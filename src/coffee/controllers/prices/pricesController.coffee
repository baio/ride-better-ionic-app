app.controller "PricesController", ($scope, pricesViewResolved, $ionicSlideBoxDelegate, $timeout, $window) ->

  console.log "PricesController", pricesViewResolved

  $scope.prices = pricesViewResolved

  $scope.$on '$ionicView.enter', ->
    $timeout (-> $ionicSlideBoxDelegate.update()), 0

  $scope.moveNext = ->
    $ionicSlideBoxDelegate.next()

  $scope.movePrev = ->
    $ionicSlideBoxDelegate.previous()