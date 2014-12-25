app.controller "MainController", ($scope, stateResolved, $state, amMoment) ->

  console.log "mainController.coffee:3 >>>"
  $scope.$root.state = stateResolved

  console.log "mainController.coffee:6 >>>", $scope.$root.state

  $scope.spot = stateResolved.spot
  $scope.culture = stateResolved.culture

  amMoment.changeLocale stateResolved.culture.lang

  $scope.open = (state) ->
    $state.transitionTo("main." + state, {id : stateResolved.spot.id, culture : stateResolved.culture.code})



