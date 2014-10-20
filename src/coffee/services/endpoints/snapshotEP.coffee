app.factory "snapshotEP", ($q, $http, webApiConfig, user, mapper, cache) ->

  get : (spot) ->
    # best, good, normal, bad, worst
    console.log "snapshot::get", spot
    $q.when
      report :
        messages : [
          {tracks : "best", snowing : "bad", crowd : "normal", time : "сегодня 10:00"}
        ]
      forecast :
        time : "сегодня 10:20"
        cumulativeSnow : 25
        todaySnow : 5
        weather : "Sunny"
        temperature : -15
        units :
          deep : "mm"
          temp : "C"
