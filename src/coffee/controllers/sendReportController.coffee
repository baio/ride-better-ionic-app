app.controller "SendReportController", ($scope, reportsDA, user, $state, $ionicSlideBoxDelegate, notifier, $q) ->

  console.log "SendReport Controller"

  $scope.data =
      tracks : null
      snowing : null
      crowd : null

  $scope.sendReport = ->
    if !$scope.data.tracks and !$scope.data.snowing and !$scope.data.crowd and !$scope.data.message
      notifier.message "Please input some data to send"
      $q.when()
    else
      data =
        conditions :
          tracks : parseInt $scope.data.tracks
          snowing : parseInt $scope.data.snowing
          crowd : parseInt $scope.data.crowd
        comment : $scope.data.message

      reportsDA.send(user.getHome().code, data).then (res) ->
        $state.go "main.home", { id : $scope.$root.currentSpot }

  $scope.cancelReport = ->
    $state.go "main.home", { id : $scope.$root.currentSpot }

  $scope.nextSlide = ->
    $ionicSlideBoxDelegate.next()

  $scope.closedReport = ->
    $state.go "main.closed", { id : $scope.$root.currentSpot }
