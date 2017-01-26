require('dotenv').config()
repo = require '../src/statements/repo'
{loadUserState} = require '../src/statements/queries'
setup = require './setup'
expect = require('chai').expect
cleanDb = require './before'
userRepo = require '../src/user/repo'

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
		repo.select()
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

	it 'selects private only for logged owners', (done) ->
		userId = null
		cleanDb()
		.then ->
			userRepo.insert socialId: 88989, socialNetwork: 'facebook'
		.then (inserted) ->
			userId = inserted
			repo.add
				text: 'public'
				userId: userId
		.then ->
			repo.add
				text: 'private'
				userId: userId
				isPrivate: yes
		.then ->
			repo.select()
		.then (result) ->
			count = Object.getOwnPropertyNames(result.entities).length
			expect(count, 'Private is not hidden').to.be.equal 1
		.then ->
			repo.select loggedUserId: 9999, userId: userId
		.then (result) ->
			count = Object.getOwnPropertyNames(result.entities).length
			expect(count, 'Private is not hidden').to.be.equal 1
		.then ->
			repo.select loggedUserId: userId, userId: userId
		.then (result) ->
			count = Object.getOwnPropertyNames(result.entities).length
			expect(count, 'Private is not shown').to.be.equal 2
			done()
		.catch ({error}) ->
			done error
		return

	it.only 'loads default user state when logged', (done) ->
		userIdMine = null
		userIdSomebody = null
		cleanDb()
		.then ->
			userRepo.insert socialId: 98765, socialNetwork: 'facebook'
		.then (inserted) ->
			userIdSomebody = inserted
			userRepo.insert socialId: 88989, socialNetwork: 'facebook'
		.then (inserted) ->
			userIdMine = inserted
			repo.add
				text: 'mine'
				userId: userIdMine
		.then ->
			repo.add
				text: 'mine private'
				userId: userIdMine
				isPrivate: yes
		.then (privateId) ->
			repo.add
				text: 'mine private child 1'
				userId: userIdMine
				ancestor: privateId
				agree: yes
		.then (privateId) ->
			repo.add
				text: 'mine private child 1.1'
				userId: userIdMine
				ancestor: privateId
				agree: yes
		.then ->
			repo.add
				text: 'somebody'
				userId: userIdSomebody
		.then ->
			repo.add
				text: 'somebody private'
				userId: userIdSomebody
				isPrivate: yes
		.then (privateId) ->
			repo.add
				text: 'somebody private child'
				userId: userIdSomebody
				ancestor: privateId
				agree: yes
		.then ->
			loadUserState id: userIdMine
		.then (result) ->
			expect(result.statementsTree).to.deep.equal '3': ['4'], '4': ['5'], root: ['2', '6', '3']
			expect(Object.getOwnPropertyNames(result.statements).length).to.equal 5
			expect(result.user['id']).to.equal 2
			expect(result.statements['4'].isChildOfPrivate).to.be.true
			expect(result.statements['5'].isChildOfPrivate).to.be.true
			done()
		.catch (error) ->
			done error
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

