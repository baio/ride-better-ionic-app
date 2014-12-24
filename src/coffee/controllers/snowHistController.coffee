app.controller "SnowHistController", ($scope, homeDA, user, resources, culture, spotResolved) ->

  console.log "snowHistController.coffee:3 >>>"
  
  $scope.chart = 
    type : "BarChart"
    options :
      legend:  position: 'top', maxLines: 3 
      isStacked: true
      height: 500
    data : []

  setChart = (data) ->        

    _rows = data.snowfallHistory.items.map (m) ->
      cmt : Math.round(m.cumulSnowAmount * 100) / 100 
      amt : Math.round((if m.type == "snow" then m.amount else 0) * 100) / 100
      date : moment.utc(m.date, "X").format("ddd")

    _rows = _rows.reverse()

    rows = _rows.map (m) ->
      c : [{v : m.date}, {v : m.cmt}, {v : m.amt}]

    $scope.chart.options.title = resources.str("Snowfall History") + " (" + resources.str(culture.heightU()) + ".)"
    $scope.chart.options.vAxis = title: resources.str("Days"),  titleTextStyle: {color: 'blue'}
    $scope.chart.data =
      cols : [
        {id: "t", label: resources.str("Days"), type: "string"},     
        {id: "z", label: resources.str("Cumulative"), type: "number"}, 
        {id: "s", label: resources.str("Fall"), type: "number"},        
      ]
      rows : rows


  loadSnowHist = ->
    home = user.getHome()
    homeDA.get(spot : spotResolved, lang : user.getLang(), culture : user.getCulture())
    .then setChart

  loadSnowHist()


  



