var stateFirst = function(request, values, options) {
	return tvr.idb.open().then(function(){
		return tvr.idb.select('state')
		.then(function(state) {
			console.info('state', state);
			if (!state) {
				console.info('neni state');
				return fetch(request.clone()).then(function(response) {
					console.info('mam response');
					return response.clone();
				})
			} else {
				console.info('mam ulozenej state, budu renderovat v SW :)');
				var init = {
					status: 200,
					statusText: "OK",
					headers: {'Content-Type': 'text/html'}
				};
				tvr.index.loadState(state);
				var body = ReactDOMServer.renderToString(tvr.index.getApp());

				return new Response(tvr.index.getHtml(body), init);
			}
			// return toolbox.cacheFirst(request, values, options);
		})
	})
}

module.exports = stateFirst;
