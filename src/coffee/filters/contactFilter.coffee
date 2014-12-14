"use strict"

app.filter "contact", ($sce) ->
  (contact) ->
    if contact.type == "phone"
    	"<a href='tel:#{contact.val}' class='calm'><i class='icon ion-ios7-telephone-outline'></a>"
    else
    	"<a target='_blank' href='#{contact.val}' class='calm'><i class='icon ion-social-rss-outline'></a>"
