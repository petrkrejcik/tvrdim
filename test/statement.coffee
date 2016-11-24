setup = require './setup'
repo = require '../src/statements/repo'

getRandomString = (length = 7) ->
	Math.random().toString(36).substring length

root1 =
	text: 'root1'
root2 =
	text: 'root2'
child1 =
	text: 'child of root1'
	parentId: null
child2 =
	text: 'child of child1'
	parentId: null
child3 =
	text: 'child of root2'
	parentId: null

describe 'Statement API', ->

	it 'adds new statement', (done) ->
		rootId = null
		repo.add root1
		.then (result) ->
			child1.parentId = result
			repo.add child1
		.then (result) ->
			child2.parentId = result
			repo.add child2
		.then -> repo.add root2
		.then (result) ->
			child3.parentId = result
			repo.add child3
		.then -> done()
		.catch done
		return

	it 'selects all statements', (done) ->

		repo.getAll()
		.then (statements) ->
			console.info 'got all'
			console.log JSON.stringify(statements, null, 4)
		.then -> done()
		.catch done


		return