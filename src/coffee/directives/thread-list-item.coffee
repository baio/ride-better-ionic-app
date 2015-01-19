app.directive "threadListItem", ($compile, boardThreadType) ->
    
  restrict: 'E'

  scope: true
        
  link:  (scope, element, attributes, ctrls) ->

    scope.$watch "thread", (val) -> 
      console.log "thread-list-item.coffee:13 >>>" 
      template = boardThreadType.getThreadTemplate(val)
      element.html(template)
      $compile(element.contents())(scope)    


