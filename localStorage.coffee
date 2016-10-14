module.exports =

	set: (LocalStorage) ->
		@_localStorage = new LocalStorage './storage'
		return

	getStorage: ->
		unless @_localStorage
			throw 'No storage set!'
		@_localStorage

	initMock: (key) ->
		mock = require './storageMock'
		@getStorage().setItem key, JSON.stringify mock
		return

	load: (key) ->
		stored = JSON.parse @getStorage().getItem key
		return stored if stored
		@initMock key
		@load()
		return
