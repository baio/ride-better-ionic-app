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
    hoursList : [1..24].map (m) -> val : m, label : m.toString() 

  scope.data.time = scope.hoursList[11]
  scope.data.transport = scope.transportTypesList[2]

  scope.validate = ->
    if !scope.data.from
      return "from_town_required"

  scope.reset = ->
    scope.data =
      message : null
      from : null
      date : new Date()
      time : null
      transport : null
      price : null
      phone : null
      time : scope.hoursList[11]
      transport : scope.transportTypesList[2]

  scope.getSendThreadData = ->
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

  scope : scope
