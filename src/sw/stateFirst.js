var stateFirst = function(request, values, options) {
	var fetchFromServer = function() {
		return fetch(request.clone()).then(function(response) {
			return response.clone();
		})
	}

	var refreshState = request.url.indexOf('refreshState=1');
	return tvr.idb.select('state')
	.then(function(state) {
		if (state) {
			var responseHeaders = {
				status: 200,
				statusText: "OK",
				headers: {'Content-Type': 'text/html'}
			};
			if (refreshState) {
				state.layout.statements.isFetching = true;
			}
			tvr.index.loadState(state);
			var body = ReactDOMServer.renderToString(tvr.index.getApp());

			return new Response(tvr.index.getHtml(body), responseHeaders);
		} else {
			return fetchFromServer();
		}
		// return toolbox.cacheFirst(request, values, options);
	})
}

module.exports = stateFirst;
