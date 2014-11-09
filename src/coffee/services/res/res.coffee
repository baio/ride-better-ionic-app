app.factory "res", (res_ru) ->

  langs =
    ru : res_ru

  _lang = "en"

  str : (txt) ->
    lang = langs[_lang]
    if lang
      lang[txt]
    else
      txt

  setLang : (lang) -> _lang = lang



