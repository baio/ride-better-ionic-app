app.service "reportFormScope", ->

  scope =
    data :
      message : null
      meta : null

  scope.validate = ->
    if !scope.data.message
      return "message_required"

  scope.reset = ->
    scope.data.message = null
    scope.data.meta = null

  scope.getSendThreadData = ->
    message : scope.data.message
    meta : scope.data.meta

  scope : scope
