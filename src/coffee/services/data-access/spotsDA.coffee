app.factory "spotsDA", ($q, spotsEP) ->


  inProgress = false

  get : (id) ->
    if inProgress
      $q.reject(new Error "In Progress")
    else
      inProgress = true
      spotsEP.get(id)["finally"] ->
        inProgress = false

  find : (term, geo) ->
    if inProgress
      $q.reject(new Error "In Progress")
    else
      inProgress = true
      spotsEP.find(term, geo)["finally"] ->
        inProgress = false

  nearest : (geo) ->
    if inProgress
      $q.reject(new Error "In Progress")
    else
      inProgress = true
      spotsEP.nearest(geo)["finally"] ->
        inProgress = false
