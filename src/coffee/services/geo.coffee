"use strict"

app.filter "geo", ($sce) ->
  (geo) ->    
    $sce.trustAsHtml("<a href='geo:#{geo.join(",")}' class='calm' style='text-decoration: none'><i class='icon ion-ios7-location'></i> &nbsp; #{geo.join(" ")}</a>")
