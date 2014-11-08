"use strict"

app.filter "capitalize", ->
  (str) ->
    if str
      str[0].toString().toUpperCase() + str[1..]