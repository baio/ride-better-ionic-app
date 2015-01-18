app.directive "threadListItem", ($compile, boardThreadType) ->

  getTemplate = (type) ->
    $templateCache.get "messages/#{type}-list-item.html"
    
  restrict: 'E'

  scope: true
        
  link:  (scope, element, attributes) ->

    scope.$watch "thread", (val) -> 
      template = boardThreadType.getThreadTemplate(val)
      element.html(template)
      $compile(element.contents())(scope)    


