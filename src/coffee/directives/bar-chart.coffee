app.directive "barChart", ->

  restrict: 'E'

  scope:
    chartData : "="

  templateUrl: "charts/bar-chart.html"    

  controller: ($scope, $element) ->

    items = $scope.chartData.items
    max = Math.max items.map((i) -> i.cmt)...
    items = items.map (m) ->
      cmt = (m.cmt / max) * 100
      amt = (m.amt / max) * 100            
      label : m.label
      cmt : cmt
      amt : amt
      amtp : (amt / cmt) * 100
      cmtp : 100 - (amt / cmt) * 100


    $scope.items = items.map (m) ->
      label : m.label
      style : { width: "#{m.cmt}%", background : "-webkit-linear-gradient(left, #387ef5, #387ef5 #{m.amtp}%, lightblue #{m.amtp}%, lightblue)" }

