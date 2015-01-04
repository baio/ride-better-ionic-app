app.factory "resources", (resources_ru, $rootScope, strings_ru, strings_en) ->

  $rootScope.resources = 
    str : {}

  angular.copy strings_en, $rootScope.resources.str

  langs =
    ru : resources_ru

  _lang = "en"

  str : (txt) ->
    lang = langs[_lang]
    if lang
      lang[txt]
    else
      txt

  setLang : (lang) -> 
    _lang = lang
    switch lang
      when "en"
        angular.copy strings_en, $rootScope.resources.str
      when "ru"
        angular.copy strings_ru, $rootScope.resources.str

  getKnownLang : (lang) ->
    lg = langs[lang]
    if lg
      return lang
    else
      "en"




