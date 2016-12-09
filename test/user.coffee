repo = require '../src/user/repo'

describe 'Users API', ->


	it 'insert user', (done) ->

		repo.insert socialId: 123456, socialNetwork: 'facebook'
		.then -> done()
		.catch done
		return


	it 'select user', (done) ->

		repo.select 123456
		.then -> done()
		.catch done
		return


	it 'select or insert', (done) ->

		repo.selectOrInsert socialId: 654321, socialNetwork: 'facebook'
		.then -> done()
		.catch done
		return

