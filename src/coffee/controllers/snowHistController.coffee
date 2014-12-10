app.controller "SnowHistController", ($scope, homeDA, user) ->

  console.log "Reports Controller"
  $scope.chart = 
    type : "BarChart"
    options :
      legend:  position: 'top', maxLines: 3 
      title: "Snowfall History"
      isStacked: true
      height: 500
      vAxis: {title: 'Days',  titleTextStyle: {color: 'blue'}}
    data : []

  setChart = (data) ->        

    _rows = data.snowfallHistory.items.map (m) ->
      cmt : Math.round m.cumulSnowAmount
      amt : Math.round if m.type == "snow" then m.amount else 0      
      date : moment.utc(m.date, "X").format("ddd")

    _rows = _rows.reverse()

    rows = _rows.map (m) ->
      c : [{v : m.date}, {v : m.cmt}, {v : m.amt}]

    $scope.chart.data =
      cols : [
        {id: "t", label: "Dates", type: "string"},     
        {id: "z", label: "Cumulative", type: "number"}, 
        {id: "s", label: "Fall", type: "number"},        
      ]
      rows : rows


  loadSnowHist = ->
    home = user.getHome()
    homeDA.get(spot : home.code, lang : user.getLang(), culture : user.getCulture())
    .then setChart

  if $scope.$root.activated
    loadSnowHist()

  $scope.$on "app.activated", loadSnowHist

  



