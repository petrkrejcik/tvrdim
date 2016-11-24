setup = require './setup'
repo = require '../src/statements/repo'

getRandomString = (length = 7) ->
	Math.random().toString(36).substring length

newStatement =
	text: getRandomString()
	# parentId: 34

describe 'Statement API', ->

	it 'adds new statement', (done) ->
		repo.add newStatement
		.then (result) ->
			console.info 'then in test'
			console.info 'resulta', result
		.then done
		.catch done
		return

	# it 'selects all statements', (done) ->

	# 	repo.getAll()
	# 	.then (statements) ->
	# 		console.info 'got all'
	# 		console.log JSON.stringify(statements, null, 4)
	# 	.then done
	# 	.catch done


		return