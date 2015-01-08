app.factory "transfer", (resources, transferFormScope, sendSimpleMsgFormScope) ->

  opts :

    thread : 

      scope : transferFormScope.scope
  
      modalTemplate : "modals/transferMsgForm.html"    

      map2send: -> 
        transferFormScope.scope.getSendThreadData()
      
      item2scope: (item) ->
        scope = transferFormScope.scope
        scope.data.message = item.text
        scope.data.from = item.meta.from
        scope.data.date = moment(item.meta.date, "X").startOf("d").toDate()
        scope.data.time = scope.hoursList[moment(item.meta.date, "X").hours() - 1]
        scope.data.transport = scope.transportTypesList.filter((f) -> f.code == item.meta.transport)[0]
        scope.data.price = item.meta.price
        scope.data.phone = item.meta.phone

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
        angular.copy item, data

      validate: (data) ->
        sendSimpleMsgFormScope.scope.validate()

      reset: ->
        sendSimpleMsgFormScope.scope.reset()        
        