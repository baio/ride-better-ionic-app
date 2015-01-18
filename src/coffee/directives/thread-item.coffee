app.directive "threadItem", ($compile, $templateCache) ->

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

  compile: ($scope, element) ->
      
    linker = (scope, element, attributes) ->      

      type = getThreadType(scope.board.data.currentThread)

      element.html(getTemplate(type))

      $compile(element.contents())(scope)    

    linker


