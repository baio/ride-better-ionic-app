app.controller "UserController", ($scope, user) ->

  console.log "userController.coffee:5 >>>", user.user

  $scope.$root.state = 
    culture : 
      code : "en-eu"
    spot : user.user.home

