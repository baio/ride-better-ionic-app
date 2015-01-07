"use strict"

app.filter "contact", ($sce) ->
  (contact) ->
    icon = "ion-social-rss-outline"
    switch contact.type
      when "phone"
        icon = "ion-android-call"
      when "site"
        icon = "ion-earth"
      when "vk"
        icon = "ion-happy-outline"
      when "facebook"
        icon = "ion-social-facebook-outline"
      when "instagram"
        icon = "ion-social-facebook-outline"
      when "facebook"
        icon = "ion-social-instagram-outline"
      when "facebook"
        icon = "ion-social-instagram-outline"
      when "skype"
        icon = "ion-social-skype-outline"
      when "email"
        icon = "ion-email"

    "<i class='calm icon #{icon}'>"