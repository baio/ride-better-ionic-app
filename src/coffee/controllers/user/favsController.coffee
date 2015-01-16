app.controller "FavsController", ($scope, $ionicModal, spotsDA, $state, geoLocator, user, $rootScope, $ionicHistory) ->

  console.log "Favs Controller"

  geo = undefined

  geoLocator.getPosition().then (res) ->
    geo = res.lat + "," + res.lon

  $scope.favs = user.user.settings.favs

  loadSpots = (term) ->
    if (!term and geo) or (term and term.length > 2)
      culture = 
        lang : user.user.settings.lang
        units : user.user.settings.culture
      spotsDA.find(term, geo, culture).then (res) ->
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
    st = id : s.code, title : s.label.replace(/<[^>]+>/gm, '')
    user.addSpot st
    $scope.spotSelectorModal.hide()

  $scope.removeFav = (s) ->
    user.removeSpot(s)

  $scope.setHome = (s) ->
    user.setHome(s)
    $scope.$root.state.spot = s

  $scope.isHome = user.isHome

  $scope.canAddFav = ->
    $scope.favs and $scope.favs.length < 10

  $scope.canRemoveFav = ->
    $scope.favs and $scope.favs.length > 1

  $scope.openHome = (fav) ->
    $state.transitionTo("root.main.home", {id : fav.id, culture : $rootScope.state.culture.code})
    #$state.go("root.main.home", {id : fav.id, culture : $rootScope.state.culture.code}, {reload : false, notify : false, location : false})

  $scope.$on "user::homeChanged", (obj, home) ->
    $scope.$root.state.spot = home




