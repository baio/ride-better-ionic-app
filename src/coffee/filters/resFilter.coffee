"use strict"

app.filter "res", (resources) ->
  (str) ->
    resources.str str
