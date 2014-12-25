app.controller "SnowHistController", ($scope, resources, stateResolved) ->

  console.log "snowHistController.coffee:3 >>>"
  
  setChart = (data) ->

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
        {y: 'amt', color: 'green', type: 'area', label :  resources.str("Fall") + " (" + resources.str(stateResolved.culture.units.names.height) + ".)"}
      ]

  setChart stateResolved



  



