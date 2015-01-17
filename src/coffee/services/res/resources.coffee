app.factory "resources", ($rootScope, strings_ru, strings_en) ->

  $rootScope.resources = 
    str : {}

  angular.copy strings_en, $rootScope.resources.str

  _lang = "en"

  str: (str) ->
    $rootScope.resources.str[str]

  setLang : (lang) -> 
    _lang = _lang
    switch lang
      when "en"
        angular.copy strings_en, $rootScope.resources.str
      when "ru"
        angular.copy strings_ru, $rootScope.resources.str

  getKnownLang : (lang) ->
    if lang == "ru"
      return lang
    else
      "en"




