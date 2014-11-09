"use strict"

app.filter "plus", ->
  (num) ->
    if num > 0
      "+" + num
    else
      num