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

  getThreadItemTemplate: (thread) ->
    type = @getThreadType thread
    type = "reports" if type == "report"
    type = "messages" if type == "message"
    $templateCache.get "messages/#{type}-item.html"

  getReplyTemplate: ->
    $templateCache.get "messages/reply-item.html"

