setup = require './setup'
repo = require '../src/statements/repo'

getRandomString = (length = 7) ->
	Math.random().toString(36).substring length

root1 =
	text: 'A'
root2 =
	text: 'B'
rootC =
	text: 'C'
child1 =
	text: 'A.A'
	parentId: null
child2 =
	text: 'A.B'
	parentId: null
child3 =
	text: 'B.A'
	parentId: null
child4 =
	text: 'A.B.A'
	parentId: null
child5 =
	text: 'A.B.B'
	parentId: null

describe 'Statement API', ->

	it 'adds new statement', (done) ->
		rootId = null
		A = null
		AB = null
		B = null
		repo.add root1 # A
		.then (result) ->
			A = result
			child1.parentId = A
			repo.add child1 # A.A
		.then (result) ->
			child2.parentId = A
			repo.add child2 # A.B
		.then (result) ->
			AB = result
			child4.parentId = AB
			repo.add child4 # A.B.A
		.then (result) ->
			child5.parentId = AB
			repo.add child5 # A.B.B
		.then -> repo.add root2 # B
		.then (result) ->
			B = result
			child3.parentId = B
			repo.add child3 # B.A
		.then -> repo.add rootC # C
		.then -> done()
		.catch done
		return

	it 'selects all statements', (done) ->

		# repo.getAll()
		repo.filterBy parentIds: [3, 4]
		.then (statements) ->
			console.info 'got all'
			console.log JSON.stringify(statements, null, 4)
		.then -> done()
		.catch done


		return