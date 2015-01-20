app.directive "collectionRepeatContainerElement", ($interpolate, boardThreadType) ->
    
  restrict: 'A'

  scope: false

  link: (scope, element, attributes) ->      
    console.log "collection-repeat-container-element.coffee:9 >>>" 
    scope.data.containerElement = element


