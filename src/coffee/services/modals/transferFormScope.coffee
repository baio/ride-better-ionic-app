app.service "transferFormScope", (resources) ->

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
      {code : "car", name : resources.str("car")}
      {code : "micro", name : resources.str("micro_bus")}
      {code : "bus", name : resources.str("bus")}
    ]
    typesList : [
      {code : "private", name : resources.str("private")}
      {code : "taxi", name : resources.str("taxi")}
      {code : "regular", name : resources.str("regular")}
    ]    
    hoursList : [1..24].map (m) -> val : m, label : m.toString() 

  scope.data.time = scope.hoursList[11]
  scope.data.transport = scope.transportTypesList[0]
  scope.data.type = scope.typesList[0]

  scope.validate = ->
    if !scope.data.from
      return "from_town_required"

  scope.reset = ->
    console.log "transferFormScope.coffee:33 >>>" 
    scope.data =
      message : null
      from : null
      date : new Date()
      time : null
      transport : null
      price : null
      phone : null
      time : scope.hoursList[11]
      type : scope.typesList[0]
      transport : scope.transportTypesList[0]

  scope.getSendThreadData = ->
    meta = angular.copy scope.data
    if meta.date and meta.type.code != "taxi"
      date = moment(meta.date).startOf("d")
      date.add(meta.time.val, "h")
      meta.date = date.utc().unix()      
    else
      meta.date = undefined
    meta.type = meta.type.code      
    meta.transport = meta.transport.code
    delete meta.time
    delete meta.message
    message : scope.data.message
    validThru: meta.date
    meta : meta

  scope : scope
