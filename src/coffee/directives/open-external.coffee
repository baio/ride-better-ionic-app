app.directive "openExternal", ->

  restrict: 'A'

  scope:
    openExternal : "@"

  link: (scope, elem, attrs) ->
    elem.bind 'click', ->
      if !scope.openExternal then return
      src = scope.openExternal.replace /-thumb\./, "."      
      if window.cordova
        ref = window.open(src, "_blank”, “location=no,EnableViewPortScale=yes,presentationstyle=pagesheet")
        ref.addEventListener("loadstop", ->
 	        screen.unlockOrientation()
	      )
        ref.addEventListener("exit", ->
          screen.lockOrientation("portrait")
        )
      else
        html = "<head><title>#{attrs.alt}</title></head><body><img src='#{src}'></body>"
        wn = window.open()
        wn.document.write(html)
      true
