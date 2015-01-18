app.directive "collectionRepeatContainerElement", ($interpolate, boardThreadType) ->
    
  restrict: 'A'

  scope: 
    collectionRepeatContainerElement : "="

  link: (scope, element, attributes) ->      
    console.log "collection-repeat-container-element.coffee:9 >>>" 
    scope.collectionRepeatContainerElement = element


