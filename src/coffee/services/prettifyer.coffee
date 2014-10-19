app.factory "prettifyer", (res) ->


  getText : (code) ->

    switch code
      when "no" then res.str.nosurf
      when "dunno" then res.str.dunno
      when "yes" then res.str.surf

  getUnkStars : (solid, faded) ->
    [0..4].map -> type : "unk"

  getStars : (solid, faded) ->

    stars = [0..4].map -> type : "empty"
    notFaded = solid - faded
    notFaded = 0 if notFaded < 0
    if notFaded >= 0
      for star, i in stars
        if notFaded > i
          stars[i].type = "solid"
        else if notFaded + faded  > i
          stars[i].type = "faded"
    stars

  getWeatherIconCss : (code) ->

    "msw-sw-" + code

  getReportIconCss : (code) ->

    switch code
      when "no" then "ion-beer"
      when "dunno" then "ion-social-tux"
      when "yes" then "ion-happy"

  getStarIconCss : (code) ->
    switch code
      when "empty" then "ion-ios7-star-outline faded"
      when "solid" then "ion-ios7-star"
      when "faded" then "ion-ios7-star-outline"

