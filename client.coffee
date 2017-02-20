client = ->
	polyf = require './src/util/polyfills'
	ReactDOM = require 'react-dom'
	index = require './index'
	idb = require './src/lib/idb'
	cookieParser = require './src/util/cookieParser'
	{SAVE_STATE, SYNC_STATE_HYDRATE, SYNC_REQUEST} = require './src/sync/actionTypes'
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
				document.cookie = 'user=; expires=Thu, 01 Jan 1970 00:00:01 GMT; path=/'
			if cookies.refreshState
				document.cookie = 'refreshState=; expires=Thu, 01 Jan 1970 00:00:01 GMT; path=/'
				store.dispatch type: SYNC_STATE_HYDRATE

		store.dispatch type: SAVE_STATE
		store.dispatch type: SYNC_REQUEST

		ReactDOM.render index.getApp(), document.getElementById 'root'

	{idb, index}

module.exports = client()
