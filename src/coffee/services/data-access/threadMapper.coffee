app.factory "threadMapper",  (user, amCalendarFilter, amDateFormatFilter, resources) ->

  trimText = (text) ->
    if text?.length > 300 then text[0..299] + "..." else text

  getImg = (thread) ->
    img = thread.data.img
    if img
      thumb : if thread.tmpImg then thread.tmpImg else img
      orig : img.replace(/thumbnail-/, "original-")

  mapReply = (reply) ->
    reply.formatted =
      shortText : if reply.data.text then trimText(reply.data.text) 
      createdStr : amCalendarFilter(reply.created)
      canEdit : user.isUser reply.user
    reply

  userRequestStatus = (thread) ->
    if thread.requests
      userRequest = thread.requests.filter((f) -> f.user.key == user.getKey())[0]
      if userRequest
        if userRequest.accepted == true
          return "accepted"
        else if userRequest.accepted == false
          return "rejected"
        else
          return "requested"      

  mapThread = (thread) ->
    if thread.formatted
      return thread
    thread.repliesCount = thread.replies.length
    thread.formatted = 
      shortText : trimText(thread.data.text)
      createdStr : amCalendarFilter(thread.created)
      metaDateStrLong : if thread.data.meta?.date then amDateFormatFilter(thread.data.meta.date, 'dddd, MMMM Do YYYY, HH:00')
      img : getImg(thread)
      canEdit : user.isUser thread.user
    if thread.tags.indexOf("transfer") != -1
      thread.formatted.transfer =
        title : resources.str(thread.data.meta.type) + " - " + resources.str(thread.data.meta.transport)
        requestStatus : userRequestStatus thread
    for reply in thread.replies
      mapReply(reply)

    thread

  mapThread : mapThread
  mapReply : mapReply
