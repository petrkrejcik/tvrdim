client = ->
	ReactDOM = require 'react-dom'
	index = require './index'
	idb = require './src/lib/idb'
	cookieParser = require './src/util/cookieParser'
	{SYNC_STATE_LOCAL, SYNC_STATE_HYDRATE} = require './src/sync/actionTypes'
	{LOGIN_SUCCESS} = require './src/user/actionTypes'

	if window?
		# in browser
		if navigator.serviceWorker?
			navigator.serviceWorker.register 'sw.js'
			console.info 'using SW'
		else
			console.info 'Service workers not supported'
		store = index.loadState window.__PRELOADED_STATE__

		if document.cookie
			cookies = cookieParser document.cookie
			if cookies.user
				store.dispatch type: LOGIN_SUCCESS, user: cookies.user
			# store.dispatch type: SYNC_STATE_HYDRATE

		store.dispatch type: SYNC_STATE_LOCAL

		ReactDOM.render index.getApp(), document.getElementById 'root'

	{idb, index}

module.exports = client()