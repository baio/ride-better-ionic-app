app.factory "baseMessages", (messages, faq, report, transfer) ->

  isThreadOfType = (thread, type) ->
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

  opts :

    thread :   

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
        getBase(thread).opts.thread.map2send(thread)
      
      item2scope: (thread) ->
        getBase(thread).opts.thread.item2scope(thread)

      validate: (thread) ->
        getBase(thread).opts.thread.validate(thread)

      reset: (thread) ->
        getBase(thread).opts.thread.reset(thread)
        
    reply : faq.opts.reply  
