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
  
  serialize: ->    
    boards = []
    if scope.data.messages
      boards.push "message"
    if scope.data.reports
      boards.push "report"
    if scope.data.faq
      boards.push "faq"
    if scope.data.transfers
      boards.push "transfer"
    spots : scope.data.spots
    boards : boards.join ","

  deserialize: (data) ->    
    console.log "filterMsgsFormScope.coffee:35 >>>", data
    if data.spots
      scope.data.spots = data.spots
    if data.boards
      scope.data.messages = false
      scope.data.reports = false
      scope.data.faq = false
      scope.data.transfers = false
      for board in data.boards.split ","
        switch board
          when "message" then scope.data.messages = true
          when "report" then scope.data.reports = true
          when "faq" then scope.data.faq = true
          when "transfer" then scope.data.transfers = true

