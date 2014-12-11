app.controller "ResortMapController", ($scope, resortsDA, user) ->

	console.log "resortMapController.coffee:3 >>>"

	$scope.maps = []
	setMaps = (res) ->		
		$scope.maps.splice 0, $scope.maps.length - 1, res...
		###
			for i in [0..4]
				if i < res.length
					$scope.maps.push res[i]
				else
					$scope.maps.push res[i]
		###					

	loadMaps = ->
	    home = user.getHome()
	    resortsDA.getMaps(home.code)
	    .then setMaps

	if $scope.$root.activated
		loadMaps()

	$scope.$on "app.activated", loadMaps

	$scope.isVisible = (index) -> $scope.maps.length > index
