"use strict"

app.filter "round", ->
  (num, dec) ->
    if num
      if dec
        m = Math.pow(10, dec)
        Math.round(num * m) / m
      else
        Math.round(num)