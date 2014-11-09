"use strict"

app.filter "res", (res) ->
  (str) ->
    res.str str
