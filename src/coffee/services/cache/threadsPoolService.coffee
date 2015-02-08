app.factory "threadsPoolService", (fifoService, threadMapper) ->

  _fifo = new fifoService.Fifo(500)

  get = (id) ->
    for f in _fifo.arr
      if f._id == id
        return f

  get : get

  fifo : _fifo

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
        _fifo.push thread
        res.push thread
    if isArray then res else res[0]









