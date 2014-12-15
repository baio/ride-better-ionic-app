"use strict"

app.filter "geo", ($sce) ->
  (geo) ->    
    _geo = angular.copy geo
    _geo = _geo.map (m) -> m.toString()[0..8]
    $sce.trustAsHtml("<a href='geo:#{geo.join(",")}' class='positive' style='text-decoration: none'><i class='icon ion-ios7-location'></i> &nbsp; #{_geo.join(" ")}</a>")
