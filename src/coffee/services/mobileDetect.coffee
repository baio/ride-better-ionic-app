app.factory "mobileDetect", ->

  md = new MobileDetect(window.navigator.userAgent)

  isMobile: -> 
    console.log "mobileDetect.coffee:6 >>>", md.mobile()
    md.mobile() or window.cordova

  mobileOS: -> 
    if window.cordova
      return 
    os = md.os()
    if os
      os = os.toLowerCase()
      if os.indexOf("ios") != -1
        return "ios"
      else if os.indexOf("android") != -1
        return "android"
      else if os.indexOf("windows") != -1
        return "wp"
