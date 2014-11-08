app.factory "mapper", ->
  mapUser: (user) ->
    res = profile : user.profile
    if user.data?.ride_better
      res.settings = user.data.ride_better
    res