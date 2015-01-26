app.factory "baseMessages", (messages, faq, report, transfer) ->

  isThreadOfType = (thread, type) ->
    if typeof thread == "string"
      return thread == type
    else
      thread.tags.indexOf(type) != -1

  getBase = (thread) ->        
    if isThreadOfType(thread, "faq")
      return faq
    else if isThreadOfType(thread, "message")
      return messages
    else if isThreadOfType(thread, "transfer")
      return transfer
    else if isThreadOfType(thread, "report")
      return report

  getBaseBoardName = (thread) ->    
    if isThreadOfType(thread, "faq")
      return "faq"
    else if isThreadOfType(thread, "message")
      return "message"
    else if isThreadOfType(thread, "transfer")
      return "transfer"
    else if isThreadOfType(thread, "report")
      return "report"

  opts :

    thread :   

      getCreateBoardName: getBaseBoardName

      scope :
        isThreadOfType : isThreadOfType
        msgForm : messages.opts.thread.scope
        faqMsgForm : faq.opts.thread.scope
        transferForm : transfer.opts.thread.scope
        reportForm : report.opts.thread.scope
        simpleMsgForm : messages.opts.reply.scope
    
      modalTemplate : (thread) -> 
        getBase(thread).opts.thread.modalTemplate

      map2send: (thread) -> 
        getBase(thread).opts.thread.map2send()
      
      item2scope: (thread) ->
        getBase(thread).opts.thread.item2scope(thread)

      validate: (thread) ->
        getBase(thread).opts.thread.validate()

      reset: (thread) ->
        getBase(thread).opts.thread.reset()
        
    reply : faq.opts.reply  
