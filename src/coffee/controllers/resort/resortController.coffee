app.controller "ResortController", ($scope, $timeout, resortResolved, $ionicSlideBoxDelegate) ->

  console.log "resortController.coffee:3 >>>"

  $scope.resort = resortResolved

  $scope.$on '$ionicView.enter', ->
    $timeout (-> $ionicSlideBoxDelegate.update()), 0

  $scope.moveNext = ->
    $ionicSlideBoxDelegate.next()

  $scope.movePrev = ->
    $ionicSlideBoxDelegate.previous()

  $scope.getContactHref = (contact) ->
    prefix = null
    if contact.type == "phone"
      prefix = "tel:"
    else if contact.type == "email"
      prefix = "mailto:"

    if prefix then prefix + contact.val else contact.val