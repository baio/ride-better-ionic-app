app.directive "threadItem", ($compile, boardThreadType, $timeout) ->

  isThreadOfType = (thread, type) ->
    if typeof thread == "string"
      return thread == type
    else
      thread.tags.indexOf(type) != -1

  getThreadType = (thread) ->    
    if isThreadOfType(thread, "faq")
      return "faq"
    else if isThreadOfType(thread, "message")
      return "message"
    else if isThreadOfType(thread, "transfer")
      return "transfer"
    else if isThreadOfType(thread, "report")
      return "report"

  getTemplate = (type) ->
    type = "reports" if type == "report"
    type = "messages" if type == "message"
    $templateCache.get "messages/#{type}-item.html"
    
  restrict: 'E'

  scope: true
      
  link = (scope, element, attributes) ->      

    console.log "thread-item.coffee:30 >>>" 
    template = boardThreadType.getThreadItemTemplate(scope.board.data.currentThread)
    element.html(template)
    $compile(element.contents())(scope)    

    ###
    TODO : buttons oh header not redrawn here !!! why ?
    scope.$watch "board.data.currentThread", (val) -> 
      console.log "thread-item.coffee:37 >>>", val
      if val
        template = boardThreadType.getThreadItemTemplate(val)
        element.html(template)
        $compile(element.contents())(scope)    
    ###        
    
    




