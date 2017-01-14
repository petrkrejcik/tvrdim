module.exports = do ->

	insert: (key, value) ->
		json = JSON.stringify value
		localStorage.setItem key, json

	select: (key) ->
		json = localStorage.getItem key
		JSON.parse json
