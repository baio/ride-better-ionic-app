"use strict"

app.filter "resourcesStr", (resources) ->
  (str) ->
    resources.str str
