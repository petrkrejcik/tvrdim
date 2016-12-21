fetch = require 'isomorphic-fetch'


sync = ->
	_storeOnServer = (statement) ->
		fetch '/api/0/statements',
			method: 'post'
			credentials: 'same-origin'
			headers:
				'Accept': 'application/json',
				'Content-Type': 'application/json'
			body: JSON.stringify statement
		.then (response) -> response.json response

	sync: (dispatch, action, state) ->
		console.info 'syncing', arguments
		yes


module.exports = sync()
