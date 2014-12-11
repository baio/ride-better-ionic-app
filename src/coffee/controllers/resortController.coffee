app.controller "ResortController", ($scope, resortsDA, user) ->

	console.log "resortController.coffee:3 >>>"

	setResort = (res) ->
		$scope.resort = res

	loadResort = ->
	    home = user.getHome()
	    resortsDA.getInfo(home.code)
	    .then setResort

	if $scope.$root.activated
		loadResort()

	$scope.$on "app.activated", loadResort
