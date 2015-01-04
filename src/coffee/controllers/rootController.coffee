app.controller "RootController", ($rootScope, stateResolved, $state, amMoment, resources) ->

  $rootScope.state = stateResolved  

  $rootScope.open = (state) ->
    $state.transitionTo("root." + state, {id : $rootScope.state.spot.id, culture : $rootScope.state.culture.code})

  console.log "rootController.coffee:10 >>>", stateResolved.culture.lang  

  amMoment.changeLocale stateResolved.culture.lang  
  resources.setLang stateResolved.culture.lang
