app.factory "messages", (resources, sendMsgFormScope, sendSimpleMsgFormScope) ->


  opts :

    thread :   

      scope : sendMsgFormScope.scope
  
      modalTemplate : "modals/sendMsgForm.html"    

      map2send: -> 
        sendMsgFormScope.scope.getSendThreadData()
      
      item2scope: (item) ->
        sendMsgFormScope.scope.data.message = item.data.text
        if item.data.meta?.priority
          sendMsgFormScope.scope.data.priority = sendMsgFormScope.scope.prioritiesList.filter((f) -> f.code == item.data.meta.priority)[0]
        if item.data.img 
          sendMsgFormScope.scope.data.photo.src = item.data.img

      validate: (data) ->
        sendMsgFormScope.scope.validate()

      reset: ->
        sendMsgFormScope.scope.reset()        
        
    reply :   

      scope : sendSimpleMsgFormScope.scope
  
      modalTemplate : "modals/sendSimpleMsgForm.html"    

      map2send: -> 
        sendSimpleMsgFormScope.scope.getSendThreadData()
      
      item2scope: (item) ->
        sendSimpleMsgFormScope.scope.data.message = item.data.text

      validate: ->
        sendSimpleMsgFormScope.scope.validate()

      reset: ->
        sendSimpleMsgFormScope.scope.reset()        
