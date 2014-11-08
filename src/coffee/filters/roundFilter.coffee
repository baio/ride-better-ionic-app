"use strict"

app.filter "round", ->
  (num, dec) ->
    console.log ">>>roundFilter.coffee:5", dec
    if num
      if dec
        m = Math.pow(10, dec)
        console.log ">>>roundFilter.coffee:9", m
        Math.round(num * m) / m
      else
        Math.round(num)