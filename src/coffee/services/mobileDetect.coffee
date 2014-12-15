app.factory "mobileDetect", ->

  md = new MobileDetect(window.navigator.userAgent)

  isMobile: -> 
    console.log "mobileDetect.coffee:6 >>>", md.mobile()
    md.mobile() or window.cordova
