app.directive "openSystem", ->

  restrict: 'A'

  scope:
    openSystem : "@"

  link: (scope, elem) ->
    elem.bind 'click', ->
      if !scope.openSystem then return
      if window.cordova
        window.open(scope.openSystem, "_system")
      else
        window.open(scope.openSystem, "_blank")
      true
