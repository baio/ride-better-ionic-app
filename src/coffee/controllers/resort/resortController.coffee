app.controller "ResortController", ($scope, resortResolved, stateResolved, amMoment, $state) ->

  console.log "resortController.coffee:3 >>>"

  $scope.spot = 
    id : resortResolved._id
    title : resortResolved.title

  $scope.$root.state = 
    culture : stateResolved.culture
    spot : $scope.spot

  console.log "resortController.coffee:10 >>>", resortResolved

  $scope.culture = stateResolved.culture

  amMoment.changeLocale stateResolved.culture.lang

  $scope.open = (state) ->
    $state.transitionTo("resort." + state, {id : resortResolved._id, culture : stateResolved.culture.code})

  $scope.resort = resortResolved


