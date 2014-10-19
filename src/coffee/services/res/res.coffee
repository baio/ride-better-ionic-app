app.factory "res", ($rootScope, res_en, res_pt, res_fr, res_es) ->

  res_current = {}

  setLang = (langName) ->
    switch langName
      when "pt" then angular.copy res_pt, res_current
      when "es" then angular.copy res_es, res_current
      when "fr" then angular.copy res_fr, res_current
      else angular.copy res_en, res_current

  setLang()

  str : res_current

  setLang : setLang



