app.service "sendSimpleMsgFormScope", ->

  scope =
    data :
      message : null
      meta : undefined

  scope.validate = ->
    if !scope.data.message
      return "message_required"

  scope.reset = ->
    scope.data.message = null
    scope.data.meta = undefined

  scope.getSendThreadData = ->
    message : scope.data.message
    meta : scope.data.meta

  scope : scope
