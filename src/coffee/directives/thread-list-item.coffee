app.directive "threadListItem", ($compile, $templateCache) ->

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
    $templateCache.get "messages/#{type}-list-item.html"
    
  restrict: 'E'

  scope: true

  compile: (scope, element) ->
      
    linker = (scope, element, attributes) ->

      # console.log "thread-list-item.coffee:30 >>>" 

      type = getThreadType(scope.thread)

      element.html(getTemplate(type))

      $compile(element.contents())(scope)    

    linker


