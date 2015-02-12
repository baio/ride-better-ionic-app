app.directive "collectionRepeatContainerElement", ->
    
  restrict: 'A'

  scope: false

  link: (scope, element) ->
    console.log "collection-repeat-container-element.coffee:9 >>>" 
    scope.data.containerElement = element


