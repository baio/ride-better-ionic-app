app.factory "transfer", (resources, transferFormScope, sendSimpleMsgFormScope) ->

  opts :

    thread : 

      scope : transferFormScope.scope
  
      modalTemplate : "modals/transferMsgForm.html"    

      map2send: -> 
        transferFormScope.scope.getSendThreadData()
      
      item2scope: (item) ->
        scope = transferFormScope.scope
        scope.data.message = item.data.text
        scope.data.from = item.data.meta.from
        if item.data.meta.date
          scope.data.date = moment(item.data.meta.date, "X").startOf("d").toDate()
          scope.data.time = scope.hoursList[moment(item.data.meta.date, "X").hours() - 1]
        scope.data.type = scope.typesList.filter((f) -> f.code == item.data.meta.type)[0]
        scope.data.transport = scope.transportTypesList.filter((f) -> f.code == item.data.meta.transport)[0]
        scope.data.price = item.data.meta.price
        scope.data.phone = item.data.meta.phone

      validate: (data) ->
        transferFormScope.scope.validate()

      reset: ->
        transferFormScope.scope.reset()        

    reply :   

      scope : sendSimpleMsgFormScope.scope
  
      modalTemplate : "modals/sendSimpleMsgForm.html"    

      map2send: -> 
        sendSimpleMsgFormScope.scope.getSendThreadData()
      
      item2scope: (item, data) ->
        sendSimpleMsgFormScope.scope.data.message = item.data.text

      validate: (data) ->
        sendSimpleMsgFormScope.scope.validate()

      reset: ->
        sendSimpleMsgFormScope.scope.reset()        
        