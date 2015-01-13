app.service "filterMsgsFormScope", ->

  scope =
    
    data :     
      spots : "favs" 
      messages : true
      reports : true
      faq : true    
      transfers : true

    setActiveFilter : (filter) ->
      if filter != @data.spots
        @data.spots = filter

    isActiveFilter : (filter) ->
      @data.spots == filter

  scope : scope
