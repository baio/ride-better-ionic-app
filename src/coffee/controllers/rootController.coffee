app.controller "RootController", ($rootScope, stateResolved, $state, amMoment) ->

  console.log "rootController.coffee:10 >>>", stateResolved

  $rootScope.state = stateResolved  

  $rootScope.open = (state) ->
    $state.transitionTo("root." + state, {id : $rootScope.state.spot.id, culture : $rootScope.state.culture.code})

  amMoment.changeLocale stateResolved.culture.lang  



