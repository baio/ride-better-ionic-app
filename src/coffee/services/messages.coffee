app.factory "messages", (resources, sendMsgFormScope) ->

  opts :
    thread :   
  
      modalTemplate : "modals/sendMsgForm.html"    

      map2send: -> 
        sendMsgFormScope.scope.getSendThreadData()
      
      data2item: (item, data) ->
        angular.copy data, item

      item2data: (item, data) ->
        angular.copy item, data

      validate: (data) ->
        sendMsgFormScope.scope.validate()

      reset: ->
        sendMsgFormScope.scope.reset();        

        
