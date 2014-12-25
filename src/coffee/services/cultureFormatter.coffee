app.factory "cultureFormatter", ->

  data =
    eu : ["km", "cm", "c"]
    uk : ["mi", "in", "c"]
    us : ["mi", "in", "f"]

  getKnownCulture: (c) ->
    if data[c]
      return c
    else
      return "eu"

  height: (cm, cre) ->
    if data[cre][1] != "cm"
      Math.round cm / 0.393701
    else
      cm

  heightU: (cre) ->
    data[cre][1]

  temp: (c, cre) ->
    if data[cre][2] != "c"
      Math.round c * 1.8 + 32
    else
      c

  tempU: (cre) ->
    console.log "cultureFormatter.coffee:30 >>>", cre
    if data[cre][2] == "c"
      "C"
    else
      "F"

  dist: (km, cre) ->
    if data[cre][0] != "km"
      Math.round km * 0.621371
    else
      km

  distU: (cre) ->
    data[cre][0]
