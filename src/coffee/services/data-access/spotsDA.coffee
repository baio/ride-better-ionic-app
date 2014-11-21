app.factory "spotsDA", ($q, spotsEP) ->


  inProgress = false

  get : (term, geo) ->
    if inProgress
      $q.reject(new Error "In Progress")
    else
      inProgress = true
      spotsEP.get(term, geo)["finally"] ->
        inProgress = false

  nearest : (geo) ->
    if inProgress
      $q.reject(new Error "In Progress")
    else
      inProgress = true
      spotsEP.nearest(geo)["finally"] ->
        inProgress = false
