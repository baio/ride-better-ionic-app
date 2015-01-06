app.directive "openExternal", ->

  restrict: 'A'

  scope:
    openExternal : "@"

  link: (scope, elem, attrs) ->
    elem.bind 'click', ->
      if window.cordova
        ref = window.open(scope.openExternal, "_blank")
        ref.addEventListener("loadstop", ->
          screen.unlockOrientation()
        )
        ref.addEventListener("exit", ->
          screen.lockOrientation("portrait")
        )
      else
        html = "<head><title>#{attrs.alt}</title></head><body><img src='#{scope.openExternal}'></body>"
        wn = window.open()
        wn.document.write(html)
      true
