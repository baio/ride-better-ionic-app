app.controller "FavsController", ($scope, $ionicModal, spot, forecast, user, $state, geoLocator) ->

  console.log "Favs Controller"

  geo = null

  $scope.favs = user.user.settings.favs

  loadSpots = (term) ->
    if (!term and geo) or (term and term.length > 2)
      spot.get(term, geo).then (res) ->
        $scope.spotsList = res.map (r) ->
          r.descr = [r.city, r.region, r.country].filter((f) -> f).join(", ")
          r
    else
      $scope.spotsList = null

  $ionicModal.fromTemplateUrl( 'modals/spotSelector.html',
    scope: $scope
    animation: 'slide-in-up'
  ).then (modal) ->
    $scope.spotSelectorModal = modal

  $scope.openSpotSelectorModal = ->
    $scope.spotSelectorModal.show()
    geoLocator.getPosition().then (res) ->
      geo = res.lat + "," + res.lon
      if !$scope.spotsList
        loadSpots()

  $scope.closeSpotSelectorModal = ->
    $scope.spotSelectorModal.hide()

  $scope.$on '$destroy', -> $scope.spotSelectorModal.remove()

  $scope.onSpotTermChanged = loadSpots

  $scope.selectSpot = (s) ->
    user.addSpot s
    $scope.spotSelectorModal.hide()

  $scope.removeFav = (s) ->
    user.removeSpot(s)

  $scope.setHome = (s) ->
    user.setHome(s)

  $scope.openHome = (s) ->
    user.setHome(s)
    $state.go "tab.home"

  $scope.isHome = user.isHome

  $scope.canAddFav = ->
    $scope.favs.length < 5

  $scope.canRemoveFav = ->
    $scope.favs.length > 1



