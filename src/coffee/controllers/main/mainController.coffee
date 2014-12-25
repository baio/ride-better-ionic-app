app.controller "MainController", ($scope, stateResolved, $state, amMoment) ->

  console.log "mainController.coffee:3 >>>"

  $scope.spot = stateResolved.spot
  $scope.culture = stateResolved.culture

  amMoment.changeLocale stateResolved.culture.lang

  $scope.open = (state) ->
    console.log "mainController.coffee:9 >>>", state, stateResolved
    $state.transitionTo("main." + state, {id : stateResolved.spot.id, culture : stateResolved.culture.code})



