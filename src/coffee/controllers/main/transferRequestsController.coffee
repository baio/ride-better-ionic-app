app.controller "TransferRequestsController", ($scope, thread, stateResolved, boardDA) ->

  console.log "transferRequestsController.coffee:3 >>>", thread

  $scope.thread = thread

  $scope.switchAccepted = (request) ->
    console.log "transferRequestsController.coffee:8 >>>"
    f = !request.accepted
    boardDA.acceptTransferRequest(thread._id, request.user.key, f).then ->
      request.accepted = f

