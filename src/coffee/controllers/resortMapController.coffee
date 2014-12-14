app.controller "ResortMapController", ($scope, resortsDA, user) ->

	console.log "resortMapController.coffee:3 >>>"

	$scope.maps = []
	setMaps = (res) ->		
		$scope.maps.splice 0, $scope.maps.length - 1, res.maps...

	loadMaps = ->
	    home = user.getHome()
	    resortsDA.getInfo(home.code)
	    .then setMaps

	if $scope.$root.activated
		loadMaps()

	$scope.$on "app.activated", loadMaps

	$scope.isVisible = (index) -> $scope.maps.length > index
