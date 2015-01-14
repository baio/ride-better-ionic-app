app.controller "RootController", ($rootScope, stateResolved, $state, amMoment, resources) ->

  console.log "rootController.coffee:3 >>>"
   
  $rootScope.open = (state) ->
    $state.transitionTo("root." + state, {id : $rootScope.state.spot.id, culture : $rootScope.state.culture.code})

  $rootScope.state = stateResolved
  amMoment.changeLocale stateResolved.culture.lang  
  resources.setLang stateResolved.culture.lang
