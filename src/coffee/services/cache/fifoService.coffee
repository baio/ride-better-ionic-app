class FifoArray

  constructor: (@max) ->
    @arr = []

  push: (el) ->
    @arr.pop() while @arr.length > @max
    @arr.splice 0, 0, el

  arr: @arr


app.factory "fifoService", ->

  Fifo : FifoArray