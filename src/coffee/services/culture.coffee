app.factory "culture", ($rootScope) ->

  culture = "eu"

  data =
    eu : ["km", "cm", "c"]
    uk : ["mi", "in", "c"]
    us : ["mi", "in", "f"]

  getKnownCulture: (c) ->
    if data[c]
      return c
    else
      return "eu"

  setCulture: (c) ->
    if data[c]
      culture = c
    else
      console.log ">>>culture.coffee:14", "Culture #{c} not found set default 'eu'"
      culture = "eu"

  getCulture: -> culture

  height: (cm) ->
    if data[@getCulture()][1] != "cm"
      Math.round cm / 0.393701
    else
      cm

  heightU: ->
    data[@getCulture()][1]

  temp: (c) ->
    if data[@getCulture()][2] != "c"
      Math.round c * 1.8 + 32
    else
      c

  tempU: ->
    if data[@getCulture()][2] == "c"
      "C"
    else
      "F"

  dist: (km) ->
    if data[@getCulture()][0] != "km"
      Math.round km * 0.621371
    else
      km

  distU: ->
    data[@getCulture()][0]
