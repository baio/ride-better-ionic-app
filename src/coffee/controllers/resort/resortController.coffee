app.controller "ResortController", ($scope, $timeout, resortResolved, $ionicSlideBoxDelegate) ->

  console.log "resortController.coffee:3 >>>"

  $scope.resort = resortResolved

  $scope.$on '$ionicView.enter', ->
    $timeout (-> $ionicSlideBoxDelegate.update()), 0

  $scope.moveNext = ->
    $ionicSlideBoxDelegate.next()

  $scope.movePrev = ->
    $ionicSlideBoxDelegate.previous()