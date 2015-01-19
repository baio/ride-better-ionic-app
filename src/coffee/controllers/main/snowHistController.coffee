app.controller "SnowHistController", ($scope, resources, stateResolved, cultureFormatter, histDA, userResolved) ->

  console.log "snowHistController.coffee:3 >>>"
  
  units = stateResolved.culture.units

  round = (val) ->
    Math.round(val * 100) / 100 

  $scope.chartData = 
    items : null

  $scope.chartType = "spot"

  isChartOfType = (type) ->
    $scope.chartType == type    

  $scope.isChartOfType = isChartOfType
  
  $scope.setChartType = (type) -> 
    if $scope.chartType != type
      $scope.chartType = type
      loadChart()

  getFavName = (id) -> userResolved.settings.favs.filter((f) -> f.id == id)[0].title

  setSpotChart = (items) ->          

    dataItems = items.map (m, i) ->
      cmt = round(m.cumulSnowAmount)
      amt = round(if m.type == "snow" then m.amount else 0)
      cmt : cmt
      amt : [amt]
      label : moment.utc(m.date, "X").format("ddd DD MMM") + 
        """ - #{Math.round(cultureFormatter.height(amt, units))} #{resources.str(cultureFormatter.heightU(units))}. -
        #{Math.round(cultureFormatter.height(cmt, units))} #{resources.str(cultureFormatter.heightU(units))}."""

    dataItems.reverse()    

    $scope.chartData.items = dataItems

  setFavsChart = (spots) ->          
    max = Math.max spots.map((m) -> m.items[m.items.length - 1].cumulSnowAmount)...
    dataItems = spots.map (m, i) ->
      cmt = 100
      amt = round (m.items[m.items.length - 1].cumulSnowAmount / max) * 100 
      amt_l = round m.items[m.items.length - 1].cumulSnowAmount

      cmt : cmt
      amt : [amt]
      label : "#{Math.round(cultureFormatter.height(amt_l, units))} #{resources.str(cultureFormatter.heightU(units))}. " + getFavName(m.spot)

    dataItems.sort (a, b) -> a.amt[0] < b.amt[0]

    $scope.chartData.items = dataItems

  loadChart = ->
    favs = userResolved.settings.favs.map((m) -> m.id).join("-")
    if isChartOfType("spot")
      histDA.getSnowfall(stateResolved.spot.id, favs).then (res) ->
        if res.length 
          setSpotChart res[0].items
    else if isChartOfType("favs")
      histDA.getSnowfall(favs, favs).then (res) ->
        setFavsChart res

  $scope.$on "$ionicView.enter", ->
    loadChart()
    


  



