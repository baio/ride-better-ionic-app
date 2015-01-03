app.controller "TransferListController", ($scope, $state, board, stateResolved, transfer) ->

  console.log "Transfer List Controller"

  $scope.board = board

  $scope.data = transfer.scope.data
  $scope.transportTypesList = transfer.scope.transportTypesList
  $scope.hoursList = transfer.scope.hoursList

  board.init stateResolved.spot.id, $scope, "transfer", null, transfer.opts

  board.loadMoreThreads()

  $scope.openThread = (threadId) ->
    $state.transitionTo("root.transfer.item", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})

  ###
  $scope.data = 
    message : null
    from : null
    date : new Date()
    time : null
    transport : null
    price : null
    phone : null

  sendOpts = 
  
    thread : 
  
      modalTemplate : "modals/transferMsgForm.html"    
      
      map2send: (data) -> 
        meta = angular.copy $scope.data
        date = moment(meta.date).startOf("d")
        date.add(meta.time.val, "h")
        meta.date = date.utc().unix()      
        meta.transport = meta.transport.code
        delete meta.time
        delete meta.message
        message : $scope.data.message
        validThru: meta.date
        meta : meta
      
      data2item: (item, data) ->
        item.text = data.message
        item.meta.from = data.meta.from
        item.meta.date = moment.utc(data.meta.date, "X").unix()
        item.meta.transport = data.meta.transport
        item.meta.price = data.meta.price
        item.meta.phone = data.meta.phone
        console.log "transferListController.coffee:37 >>>", item

      item2data: (item, data) ->
        $scope.data.message = item.text
        $scope.data.from = item.meta.from
        $scope.data.date = moment(item.meta.date, "X").startOf("d").toDate()
        $scope.data.time = $scope.hoursList[moment(item.meta.date, "X").hours() - 1]
        $scope.data.transport = $scope.transportTypesList.filter((f) -> f.code == item.meta.transport)[0]
        $scope.data.price = item.meta.price
        $scope.data.phone = item.meta.phone

      validate: (data) ->

  board.init stateResolved.spot.id, $scope, "transfer", null, sendOpts

  board.loadMoreThreads()

  #$scope.$on '$destroy', -> board.dispose()

  $scope.openThread = (threadId) ->
    $state.transitionTo("root.transfer.item", {id : stateResolved.spot.id, culture : stateResolved.culture.code, threadId : threadId})

  $scope.transportTypesList = [
    {code : "car", name : resources.str("Car")}
    {code : "micro", name : resources.str("Micro Bus")}
    {code : "bus", name : resources.str("Bus")}
  ]

  $scope.hoursList = [1..24].map (m) -> val : m, label : m.toString() 

  $scope.data.time = $scope.hoursList[11]
  $scope.data.transport = $scope.transportTypesList[2]

  console.log "transferListController.coffee:39 >>>", $scope.data
  ###
