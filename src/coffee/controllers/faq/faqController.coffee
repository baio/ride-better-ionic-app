app.controller "FaqController", ($scope, stateResolved, $state, amMoment) ->

  console.log "faqController.coffee:3 >>>"
  $scope.$root.state = stateResolved

  $scope.spot = stateResolved.spot
  $scope.culture = stateResolved.culture

  amMoment.changeLocale stateResolved.culture.lang




