app.controller "RepliesController", ($scope, $state, board, thread, boardThreadHeight, boardThreadType, messages) ->

  console.log "RepliesController Controller"

  $scope.simpleMsgForm = messages.opts.reply.scope
  $scope.board = board
  $scope.data = 
    containerElement : null

  $scope.getReplyHeight = (reply) ->
    boardThreadHeight.getReplyHeight reply, $scope.data.containerElement
