app.factory "boardThreadType", ($templateCache) ->

  isThreadOfType: (thread, type) ->
    if typeof thread == "string"
      return thread == type
    else
      thread.tags.indexOf(type) != -1

  getThreadType: (thread) ->    
    if @isThreadOfType(thread, "faq")
      return "faq"
    else if @isThreadOfType(thread, "message")
      return "message"
    else if @isThreadOfType(thread, "transfer")
      return "transfer"
    else if @isThreadOfType(thread, "report")
      return "report"

  getThreadTemplate: (thread) ->
    $templateCache.get "messages/#{@getThreadType(thread)}-list-item.html"
