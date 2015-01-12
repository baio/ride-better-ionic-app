app.controller "SendReportController", ($scope, boardDA, $ionicSlideBoxDelegate, notifier, $q, stateResolved) ->

  console.log "SendReport Controller"

  $scope.data =
      tracks : null
      snowing : null
      crowd : null

  $scope.sendReport = ->
    if !$scope.data.tracks and !$scope.data.snowing and !$scope.data.crowd and !$scope.data.message
      notifier.message "data_required"
      $q.when()
    else
      data =
        meta :
          conditions :
            tracks : parseInt $scope.data.tracks
            snowing : parseInt $scope.data.snowing
            crowd : parseInt $scope.data.crowd
        message : $scope.data.message

      boardDA.postThread({spot : stateResolved.spot.id, board : "report"}, data).then (res) ->
        $scope.open "main.home"

  $scope.cancelReport = ->
    $scope.open "main.home"

  $scope.nextSlide = ->
    $ionicSlideBoxDelegate.next()

  $scope.closedReport = ->
    $scope.open "main.closed"
