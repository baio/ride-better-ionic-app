app.factory "webcamsDA", (webcamsEP, mobileDetect) ->

  latest : (opts) -> 
    if mobileDetect.isMobile()
      opts.nostream = true
    webcamsEP.latest opts

  prev : (opts) ->
    if mobileDetect.isMobile()
      opts.nostream = true    
    webcamsEP.prev opts
  
  next : (opts) ->
    if mobileDetect.isMobile()
      opts.nostream = true        
    webcamsEP.next opts