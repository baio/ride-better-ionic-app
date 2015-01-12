app.controller "SnowHistController", ($scope, resources, homeResolved, stateResolved, cultureFormatter) ->

  console.log "snowHistController.coffee:3 >>>"
  
  units = stateResolved.culture.units

  setChart = (data) ->          

    data =       
      items : data.snowfallHistory.items.map (m, i) ->
        cmt = Math.round(m.cumulSnowAmount * 100) / 100 
        amt = Math.round((if m.type == "snow" then m.amount else 0) * 100) / 100
        cmt : cmt
        amt : amt
        label : moment.utc(m.date, "X").format("ddd DD MMM") + 
          """ - #{Math.round(cultureFormatter.height(amt, units))} #{resources.str(cultureFormatter.heightU(units))}. -
          #{Math.round(cultureFormatter.height(cmt, units))} #{resources.str(cultureFormatter.heightU(units))}."""

    data.items.reverse()

    console.log "snowHistController.coffee:30 >>>", data

    $scope.data = data

  setChart homeResolved



  



