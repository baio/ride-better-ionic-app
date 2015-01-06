app.factory "resortsEP", (_ep) ->
	
	getInfo: (spot) ->
  	
  		_ep.get "resorts/" + spot + "/info"

	getMaps: (spot) ->
		  	
  		_ep.get "resorts/" + spot + "/maps"


	getPrices: (spot) ->
		  	
  		_ep.get "resorts/" + spot + "/prices"

	postPrice: (spot, file, data) ->

		_ep.postFile "resorts/" + spot + "/price", file, data, true
