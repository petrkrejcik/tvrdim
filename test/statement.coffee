repo = require '../src/statements/repo'
setup = require './setup'
expect = require('chai').expect

getRandomString = (length = 7) ->
	Math.random().toString(36).substring length

root1 =
	text: 'A'
root2 =
	text: 'B'
rootC =
	text: 'C'
rootD =
	text: 'D'
child1 =
	text: 'A.A'
	agree: no
child2 =
	text: 'A.B'
	agree: yes
child3 =
	text: 'B.A'
	agree: no
child4 =
	text: 'A.B.A'
	agree: no
child5 =
	text: 'A.B.B'
	agree: yes
childD =
	text: 'D.A'
	agree: yes

describe 'Statement API', ->

	it 'adds new statement', (done) ->
		rootId = null
		repo.add text: 'A'
		.then (id) ->
			expect(id).to.equal '2'
			rootId = id
			repo.add
				ancestor: rootId
				text: 'A.A'
				agree: no
		.then (result) ->
			expect(result).to.equal '3'
			repo.add
				ancestor: result
				text: 'A.A.A'
				agree: no
		.then (id) ->
			repo.add
				ancestor: rootId
				text: 'A.B'
				agree: yes
		.then -> done()
		.catch done
		return

	it 'selects all statements', (done) ->
		repo.getAll()
		# repo.filterBy parentIds: [3, 4]
		.then (statements) ->
			expect(statements.entities['2'].score, 'Score is wrong').to.equal 1
			expect(statements.tree['2']).to.have.length 2
			expect(statements.tree['2'][0]).to.equal '3'
			expect(statements.tree['root']).to.have.length 1
			expect(statements.tree['root'][0]).to.equal '2'
			done()
		.catch done
		return

	it 'removes statement', (done) ->
		repo.remove 2, undefined, 2
		.then (ids) ->
			console.info 'removed', ids
		.then -> done()
		.catch (err) ->
			console.info 'errr', err
			done err
		return

