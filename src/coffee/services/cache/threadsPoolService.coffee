app.factory "threadsPoolService", (fifoService, threadMapper) ->

  fifo = new fifoService.Fifo(500)

  get = (id) ->
    for f in fifo       
      if f._id == id
        console.log "!!!", f, fifo
        return f

  get : get

  fifo : fifo

  push: (threads) ->
    res = []
    isArray = Array.isArray threads
    threads = [threads] if !isArray
    for _thread in threads
      thread = threadMapper.mapThread _thread      
      existed = get(thread._id)
      if existed        
        if thread != existed
          angular.copy thread, existed
        res.push existed
      else
        fifo.push thread
        res.push thread
    if isArray then res else res[0]








