"use strict"

app.filter "contact", ($sce) ->
  (contact) ->
    if contact.type == "phone"
    	"<a href='tel:#{contact.val}'><i class='icon ion-ios7-telephone-outline'></a>"
    else if contact.type == "geo"
      $sce.trustAsHtml("<a href='geo:53.33196,6.92583'><i class='icon ion-ios7-location-outline'></a>")
    else
    	"<a target='_blank' href='#{contact.val}'><i class='icon ion-social-rss-outline'></a>"
