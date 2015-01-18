app.factory "boardThreadHeight", (boardThreadType, $interpolate) ->

  getThreadContentDim = (thread, containerElement) ->
    template = boardThreadType.getThreadTemplate(thread)
    exp = $interpolate(template)
    html = exp(thread : thread)
    html = "<div class='item item-text-wrap' style='width: 100%; position: absolute; -webkit-transform: translate3d(-2000px, -2000px, 0)'>" + html + "</div>"
    newElement = angular.element(html)
    containerElement.append(newElement)      
    offsetHeight = newElement[0].offsetHeight
    offsetWidth = newElement[0].children[0].offsetWidth
    newElement.remove()
    width : offsetWidth, height : offsetHeight

  getImageHeigth = (thread, contentWidth) ->
    if thread.data.img      
      regex = /^.*-(\d{1,3}x\d{1,3})\.(gif|jpg|png)$/g
      match = regex.exec thread.data.img
      if match
        dim = match[1]
        spts = dim.split "x"
        width = parseInt spts[0]
        height = parseInt spts[1]
        #scale to thumb size
        h = (contentWidth / width) * height
        return h
      else
        return 300
    return 0

  getMessageHeigth = (thread, containerElement) ->
    contentDim = getThreadContentDim thread, containerElement
    imgHeight = getImageHeigth thread, contentDim.width
    contentDim.height + imgHeight

  getReportHeigth = (thread, containerElement) ->
    getThreadContentDim(thread, containerElement).height
  
  getTransferHeigth = (thread, containerElement) ->  
    getThreadContentDim(thread, containerElement).height

  getFaqHeigth = (thread, containerElement) ->  
    getThreadContentDim(thread, containerElement).height

  getHeight: (thread, containerElement) ->
    if thread.__meta?.listItemHeight
      return thread.__meta.listItemHeight
    height = switch boardThreadType.getThreadType thread
      when "message" then getMessageHeigth thread, containerElement
      when "report" then getReportHeigth thread, containerElement
      when "faq" then getTransferHeigth thread, containerElement
      when "transfer" then getTransferHeigth thread, containerElement
    thread.__meta ?= {}
    thread.__meta.listItemHeight = height  
    height

