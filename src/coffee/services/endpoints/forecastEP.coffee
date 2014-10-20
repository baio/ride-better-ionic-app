app.factory "forecastEP", ($q, $resource, webApiConfig, mapper, cache) ->


  get : (spot) ->

    $q.when
      items : [
        time : "сегодня 10:20"
        cumulativeSnow : 25
        todaySnow : 5
        weather : "Sunny"
        temperature : -15
      ,
        time : "завтра 10:30"
        cumulativeSnow : 35
        todaySnow : 1
        weather : "Sunny"
        temperature : -25
        isCurrent : true
      ],
      units :
        deep : "mm"
        temp : "C"



