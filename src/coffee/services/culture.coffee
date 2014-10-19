app.factory "culture", ($rootScope) ->

  culture = "eu"

  data =
    eu : ["m", "kph", "c", "km"]
    uk : ["ft", "mph", "c", "mi"]
    us : ["ft", "mph", "f", "mi"]

  setCulture: (c) -> culture = c

  getCulture: -> culture

  getHeight: (m) ->

    if data[@getCulture()][0] != "m"
      Math.round m * 3.2808
    else
      m

  getHeightUnits: ->
    data[@getCulture()][0]

  getSpeed: (s) ->
    if data[@getCulture()][1] != "mph"
      Math.round 1.6 * s
    else
      s

  getSpeedUnits: ->
    data[@getCulture()][1]

  getTemp: (c) ->
    if data[@getCulture()][2] != "c"
      Math.round c * 1.8 + 32
    else
      c

  getTempUnits: ->
    if data[@getCulture()][2] == "c"
      "c"
    else
      "F"

  getDist: (km) ->
    if data[@getCulture()][3] != "km"
      Math.round km * 0.621371
    else
      km

  getDistUnits: ->
    data[@getCulture()][3]
