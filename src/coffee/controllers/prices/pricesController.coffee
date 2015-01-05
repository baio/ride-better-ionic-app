app.controller "PricesController", ($scope, pricesViewResolved, $ionicSlideBoxDelegate, $timeout, $window) ->

  console.log "PricesController", pricesViewResolved

  $scope.prices = pricesViewResolved

  $scope.$on '$ionicView.enter', ->
    $timeout (-> $ionicSlideBoxDelegate.update()), 0

  $scope.openImg = (image) ->
    ###
    console.log image
    wn = $window.open("", "_system");
    console.log wn
    wn.document.write("<head><title>#{image.title}</title></head><body><img src='#{image.src}' width='100%' height='100%'></body>");
    ###
    html = "<head><title>#{image.title}</title></head><body><img src='#{image.src}' width='100%' height='100%'></body>"
    ref = window.open(image.src, "_blank")
    ref.addEventListener("loadstop", ->
      screen.unlockOrientation()
    )
    ref.addEventListener("exit", ->
      screen.lockOrientation("portrait")
    )

    true