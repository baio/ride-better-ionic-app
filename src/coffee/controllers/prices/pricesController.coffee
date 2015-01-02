app.controller "PricesController", ($scope, pricesViewResolved) ->

  console.log "PricesController", pricesViewResolved

  $scope.prices = pricesViewResolved

  console.log "pricesController.coffee:7 >>>", pricesViewResolved
