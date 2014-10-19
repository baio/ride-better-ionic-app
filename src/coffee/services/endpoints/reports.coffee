app.factory "reports", ($q, $http, webApiConfig, user, mapper, cache) ->

  get : (spot) ->
    # best, good, normal, bad, worst
    console.log "reports::get", spot
    $q.when
        messages : [
          {tracks : "best", snowing : "bad", crowd : "normal", time : "сегодня 10:00", user : { name : "max" }, text : "blah"}
          {tracks : "best", snowing : "normal", crowd : "normal", time : "сегодня 09:30", user : { name : "max" }}
        ]
