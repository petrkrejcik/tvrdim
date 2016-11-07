module.exports =

	set: (LocalStorage) ->
		# initial method
		@_localStorage = new LocalStorage './storage'
		return

	getStorage: ->
		unless @_localStorage
			throw 'No storage set!'
		@_localStorage

	store: (key, value) ->
		console.info 'key', key
		stored = @load 'petrk'
		Object.assign stored[key], "#{value.id}": value
		console.info 'storing real', stored
		@getStorage().setItem 'petrk', JSON.stringify stored
		return

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
