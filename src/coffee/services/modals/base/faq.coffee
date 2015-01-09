app.factory "faq", (resources, sendSimpleMsgFormScope) ->


  opts :

    thread :   

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
