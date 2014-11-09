app.controller "SendReportController", ($scope, reportsDA, user, $state, $ionicSlideBoxDelegate, notifyer, $q) ->

  console.log "SendReport Controller"

  $scope.data =
    tracks : null
    snowing : null
    crowd : null

  $scope.sendReport = ->

    if !$scope.data.tracks and !$scope.data.snowing and !$scope.data.crowd and !$scope.data.message
      notifyer.message "Please input some data to send"
      $q.when()
    else
      home = user.getHome().code
      data =
        conditions :
          tracks : parseInt $scope.data.tracks
          snowing : parseInt $scope.data.snowing
          crowd : parseInt $scope.data.crowd
        comment : $scope.data.message

      reportsDA.send(home, data).then (res) ->
        $state.go "tab.home"

  $scope.cancelReport = ->
    $state.go "tab.home"

  $scope.nextSlide = ->
    console.log ">>>sendReportController.coffee:26"
    $ionicSlideBoxDelegate.next()

