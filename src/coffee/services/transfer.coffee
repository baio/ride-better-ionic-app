app.factory "transfer", (resources) ->

  scope = 
    
    data : 
      message : null
      from : null
      date : new Date()
      time : null
      transport : null
      price : null
      phone : null

    transportTypesList : [
      {code : "car", name : resources.str("Car")}
      {code : "micro", name : resources.str("Micro Bus")}
      {code : "bus", name : resources.str("Bus")}
    ]

    hoursList : [1..24].map (m) -> val : m, label : m.toString() 

  scope.data.time = scope.hoursList[11]
  scope.data.transport = scope.transportTypesList[2]

  scope : scope

  opts :
    thread : 
  
      modalTemplate : "modals/transferMsgForm.html"    
      
      map2send: (data) -> 
        meta = angular.copy scope.data
        date = moment(meta.date).startOf("d")
        date.add(meta.time.val, "h")
        meta.date = date.utc().unix()      
        meta.transport = meta.transport.code
        delete meta.time
        delete meta.message
        message : scope.data.message
        validThru: meta.date
        meta : meta
      
      data2item: (item, data) ->
        item.text = data.message
        item.meta.from = data.meta.from
        item.meta.date = moment.utc(data.meta.date, "X").unix()
        item.meta.transport = data.meta.transport
        item.meta.price = data.meta.price
        item.meta.phone = data.meta.phone

      item2data: (item, data) ->
        scope.data.message = item.text
        scope.data.from = item.meta.from
        scope.data.date = moment(item.meta.date, "X").startOf("d").toDate()
        scope.data.time = scope.hoursList[moment(item.meta.date, "X").hours() - 1]
        scope.data.transport = scope.transportTypesList.filter((f) -> f.code == item.meta.transport)[0]
        scope.data.price = item.meta.price
        scope.data.phone = item.meta.phone

      validate: (data) ->
