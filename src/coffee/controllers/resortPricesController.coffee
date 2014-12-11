app.controller "ResortPricesController", ($scope, resortsDA, user) ->

	console.log "ResortPricesController.coffee:3 >>>"

	$scope.prices = []
	setPrices = (res) ->		
		$scope.prices.splice 0, $scope.prices.length - 1, res...

	loadPrices = ->
	    home = user.getHome()
	    resortsDA.getPrices(home.code)
	    .then setPrices

	if $scope.$root.activated
		loadPrices()

	$scope.$on "app.activated", loadPrices

