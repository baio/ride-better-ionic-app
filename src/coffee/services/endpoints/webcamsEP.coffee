app.factory "webcamsEP", (_ep) ->

  latest : (opts) ->

    console.log "webcams::latest", opts

    _ep.get "webcams/" + opts.spot + "/" + opts.index + "/latest"
    ###
    $q.when
      current :
        _id:"5482e6d3009a190e009f3bb1"
        type : "stream"
        title : "Нижняя зона"
        spot:"1936"
        created: 1417864915
        key: "rb-1936-06-12-14-11-21-64.jpg"
        src: "http://ipeye.ru/ipeye_service/api/api.php?dev=m1G7dnol6Epo4CHLzYjAERqszxA4kz&amp;tupe=rtmp&amp;autoplay=0&amp;logo=1"
        index : 2
      list  :
        [
          {
            index : 0
            title : "Вершина, трасса 2"
          }
          {
            index : 1
            title : "Вершина, трасса 5"
          }
          {
            index : 2
            title : "Нижняя зона"
          }
        ]


    current :
      _id:"5482e6d3009a190e009f3bb1"
      type : "img"
      title : "Вершина, трасса 1"
      spot:"1936"
      created: 1417864915
      key: "rb-1936-06-12-14-11-21-64.jpg"
      src: "https://dataavail.blob.core.windows.net/ride-better-webcams/rb-1936-06-12-14-11-21-64.jpg"
      index : 0
    list  :
      [
        {
          index : 0
          title : "Вершина, трасса 2"
        }
        {
          index : 1
          title : "Вершина, трасса 5"
        }
        {
          index : 2
          title : "Нижняя зона"
        }
      ]
    ###


  prev : (opts) ->

    console.log "webcams::prev", opts

    _ep.get "webcams/" + opts.spot + "/" + opts.index +  "/prev/" + opts.time

  next : (opts) ->

    console.log "webcams::next", opts

    _ep.get "webcams/" + opts.spot + "/" + opts.index +  "/next/" + opts.time
