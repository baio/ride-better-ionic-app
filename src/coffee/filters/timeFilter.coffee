"use strict"

app.filter "time", ->
  (dateTime) ->

    moment.utc(dateTime, "DD-MM-YYYYTHH:mm").format("HH:mm")