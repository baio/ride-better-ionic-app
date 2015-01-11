app.controller "SnowHistController", ($scope, resources, homeResolved, stateResolved, cultureFormatter) ->

  console.log "snowHistController.coffee:3 >>>"
  
  _setChart = (data) ->

    $scope.data = data.snowfallHistory.items.map (m, i) ->
      cmt : Math.round(m.cumulSnowAmount * 100) / 100 
      amt : Math.round((if m.type == "snow" then m.amount else 0) * 100) / 100
      date : moment.utc(m.date, "X").format("ddd")
      idx : i

    getLabel = (val) ->
      if val % 1 == 0
        $scope.data[val].date
      else
        ""

    $scope.options =
      lineMode: 'cardinal',
      axes: 
        x: {key: 'idx', labelFunction: getLabel, type: 'linear', ticks: 7}
        y: {type: 'linear'},
      series: [
        {y: 'cmt', color: '#4682b4', type: 'area', label :  resources.str("Cumulative")},
        {y: 'amt', color: 'green', type: 'area', label :  resources.str("Fall") + " (" + resources.str(homeResolved.culture.units.names.height) + ".)"}
      ]

  units = stateResolved.culture.units

  setChart = (data) ->          

    data =       
      items : data.snowfallHistory.items.map (m, i) ->
        cmt = Math.round(m.cumulSnowAmount * 100) / 100 
        amt = Math.round((if m.type == "snow" then m.amount else 0) * 100) / 100
        cmt : cmt
        amt : amt
        label : moment.utc(m.date, "X").format("ddd DD MMM") + 
          " - #{Math.round(cultureFormatter.height(cmt, units))} / #{Math.round(cultureFormatter.height(amt, units))} #{resources.str(cultureFormatter.heightU(units))}."

    data.items.reverse()

    console.log "snowHistController.coffee:30 >>>", data

    $scope.data = data

  $scope.legend = "Total for past days / for the day"

  setChart homeResolved



  



