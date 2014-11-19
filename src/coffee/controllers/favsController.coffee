app.controller "FavsController", ($scope, $ionicModal, spotsDA, $state, geoLocator, user) ->

  console.log "Favs Controller"

  geo = undefined

  geoLocator.getPosition().then (res) ->
    geo = res.lat + "," + res.lon

  if $scope.$root.activated
    $scope.favs = user.user.settings.favs

  $scope.$on "app.activated", ->
    $scope.favs = user.user.settings.favs

  loadSpots = (term) ->
    if (!term and geo) or (term and term.length > 2)
      spotsDA.get(term, geo).then (res) ->
        $scope.spotsList = res
    else
      $scope.spotsList = null

  $ionicModal.fromTemplateUrl( 'modals/spotSelector.html',
    scope: $scope
    animation: 'slide-in-up'
  ).then (modal) ->
    $scope.spotSelectorModal = modal

  $scope.openSpotSelectorModal = ->
    $scope.spotSelectorModal.show()
    if !$scope.spotsList
      loadSpots(null)

  $scope.closeSpotSelectorModal = ->
    $scope.spotSelectorModal.hide()

  $scope.$on '$destroy', -> $scope.spotSelectorModal.remove()

  $scope.onSpotTermChanged = loadSpots

  $scope.selectSpot = (s) ->
    st = code : s.code, label : s.label.replace(/<[^>]+>/gm, '')
    user.addSpot st
    $scope.spotSelectorModal.hide()

  $scope.removeFav = (s) ->
    user.removeSpot(s)

  $scope.setHome = (s) ->
    user.setHome(s)

  $scope.openHome = (s) ->
    console.log ">>>favsController.coffee:46", s
    user.setHome(s)
    $state.go "tab.home"

  $scope.isHome = user.isHome

  $scope.canAddFav = ->
    $scope.favs and $scope.favs.length < 5

  $scope.canRemoveFav = ->
    $scope.favs and $scope.favs.length > 1



