app.directive "barChart", ->

  colors = 
    [
      "#387ef5"
      "lightblue"
    ]

  restrict: 'E'

  scope:
    chartData : "="

  templateUrl: "charts/bar-chart.html"    

  controller: ($scope, $element) ->

    $scope.$watch "chartData.items", (newVal, oldVal) ->

      if newVal and newVal != oldVal
  
        items = newVal
        max = Math.max items.map((i) -> i.cmt)...
        items = items.map (m) ->
          m.cmt = 0.001 if !m.cmt
          cmt = (m.cmt / max) * 100
          amt = m.amt.map (s) -> (s / max) * 100            
          amtp = amt.map (s) -> (s / cmt) * 100

          label : m.label
          cmt : cmt
          cmtp : 100 - (amt / cmt) * 100
          amt : amt
          amtp : amtp
          
        $scope.items = items.map (m) ->

          gradients = m.amtp.map (s, i) -> 
            color1 = colors[i]
            color2 = colors[i + 1]
            ", #{color1}, #{color1} #{s}%, #{color2} #{s}%"

          bkg = "-webkit-linear-gradient(left #{gradients}, lightblue)"

          label : m.label
          style : { width: "#{m.cmt}%", background : bkg }

