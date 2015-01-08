app.factory "messages", (resources, sendMsgFormScope, sendSimpleMsgFormScope) ->


  opts :

    thread :   

      scope : sendMsgFormScope.scope
  
      modalTemplate : "modals/sendMsgForm.html"    

      map2send: -> 
        sendMsgFormScope.scope.getSendThreadData()
      
      item2scope: (item) ->
        sendMsgFormScope.scope.data.message = item.text
        if item.meta?.priority
          sendMsgFormScope.scope.data.priority = sendMsgFormScope.scope.prioritiesList.filter((f) -> f.code == item.meta.priority)[0]
        if item.img 
          sendMsgFormScope.scope.data.photo.src = item.img

      validate: (data) ->
        sendMsgFormScope.scope.validate()

      reset: ->
        sendMsgFormScope.scope.reset()        

        
    reply :   

      scope : sendSimpleMsgFormScope.scope
  
      modalTemplate : "modals/sendSimpleMsgForm.html"    

      map2send: -> 
        sendSimpleMsgFormScope.scope.getSendThreadData()
      
      item2scope: (item, data) ->
        angular.copy item, data

      validate: (data) ->
        sendSimpleMsgFormScope.scope.validate()

      reset: ->
        sendSimpleMsgFormScope.scope.reset()        
