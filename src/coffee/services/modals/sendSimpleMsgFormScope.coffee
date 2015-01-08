app.service "sendSimpleMsgFormScope", (resources) ->

  scope =
    data :
      message : null

  scope.validate = ->
    if !scope.data.message
      return "Please add some message"

  scope.reset = ->
    scope.data.message = null

  scope.getSendThreadData = ->
    message : scope.data.message

  scope : scope
