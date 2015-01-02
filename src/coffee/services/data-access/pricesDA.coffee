app.factory "pricesDA",  (resortsDA) ->
  get: (spot) ->
    resortsDA.getInfo(spot)


  