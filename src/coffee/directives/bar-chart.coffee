app.directive "barChart", ->

  restrict: 'E'

  scope:
    chartData : "="

  templateUrl: "charts/bar-chart.html"    

  controller: ($scope, $element) ->
    console.log "bar-chart.coffee:14 >>>", $scope.chartData

    items = $scope.chartData.items
    max = Math.max items.map((i) -> i.cmt)...
    console.log "bar-chart.coffee:15 >>>", max
    items = items.map (m) ->
      cmt = (m.cmt / max) * 100
      amt = (m.amt / max) * 100            
      label : m.label
      cmt : cmt
      amt : amt
      amtp : (amt / cmt) * 100
      cmtp : 100 - (amt / cmt) * 100


    console.log "bar-chart.coffee:21 >>>", items

    $scope.items = items.map (m) ->
      label : m.label
      style : { width: "#{m.cmt}%", background : "-webkit-linear-gradient(left, lightblue, lightblue #{m.cmtp}%, #387ef5 #{m.cmtp}%, #387ef5)" }

    console.log "bar-chart.coffee:31 >>>", $scope.items