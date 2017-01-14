client = ->
	ReactDOM = require 'react-dom'
	index = require './index'
	idb = require('./src/lib/idb')('tvrdim')

	if window?
		# in browser
		console.info 'browser...'
		if navigator.serviceWorker?
			console.info 'registering sw...'
			navigator.serviceWorker.register 'sw.js'
		else
			console.info 'serviwe workers not supported'

		idb.open()
		.then ->
			idb.insert 'state', window.__PRELOADED_STATE__

		index.loadState window.__PRELOADED_STATE__
		ReactDOM.render index.getApp(), document.getElementById 'root'

	{idb, index}

module.exports = client()