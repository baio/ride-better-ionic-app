app.factory "resortsDA", (resortsEP, $q, cache) ->

  getThumb = (img) ->
    return if img then "http://wit.wurfl.io/w_350/#{img}" else img

  getCacheName = (spot) -> "resort_" + spot

  mapInfo = (info) ->
    info.headerThumb = getThumb info.header
    for price in info.prices
      price.thumb = getThumb price.src
    for map in info.maps
      map.thumb = getThumb map.src

    info

  getInfo : (spot) ->    
    cacheName = getCacheName spot
    cached = cache.get cacheName
    if cached      
      $q.when cached
    else
      resortsEP.getInfo(spot).then (res) ->
        res = mapInfo res
        cache.put cacheName, res, 60 * 3
        res

  getMaps : resortsEP.getMaps
  getPrices : resortsEP.getPrices
  postPrice : resortsEP.postPrice
