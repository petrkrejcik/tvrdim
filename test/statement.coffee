setup = require './setup'
repo = require '../src/statements/repo'

getRandomString = (length = 7) ->
	Math.random().toString(36).substring length

create = (children = []) ->
	title: getRandomString()
	text: getRandomString 10
	children: children

tree = [
	create [
		create [
			create()
		]
		# create [create [create()]]
		# create [create [create()]]
		# create [create [create()]]
		# create [create [create()]]
		# create [create [create()]]
	]
	create [create [create [create()]]]
	create [create [create [create()]]]
	# create [create [create [create()]]]
	# create [create [create [create()]]]
	# create [create [create [create()]]]
	# create [create [create [create()]]]
	# create [create [create [create()]]]
	# create [create [create [create()]]]
	# create [create [create [create()]]]
	# create [create [create [create()]]]
	# create [create [create [create()]]]
	# create [create [create [create()]]]
	# create [create [create [create()]]]
	# create [create [create [create()]]]
	# create [create [create [create()]]]
]

insert = (statement) ->
	new Promise (resolve, reject) ->
		repo.add statement
		.then (id) ->
			return resolve() unless statement.children.length
			promise = Promise.resolve()
			for child, i in statement.children
				promise = promise.then do (child, i) -> ->
					child.parentId = id
					child.agree = if Math.random() * 10 % 2 > 1 then yes else no
					insert child
					.then ->
						resolve() if i is statement.children.length - 1
					.catch (err) ->
						console.info 'err child', err
						console.info 'err st', child
						reject()
			return
		.catch reject
		return

makeTree = (done) ->
	promise = Promise.resolve()
	for item, i in tree
		promise = promise.then do (item, i) -> ->
			insert item
			.then -> done() if i is tree.length - 1
			.catch (err) -> done() if i is tree.length - 1
	return



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


		makeTree done


		# rootId = null
		# A = null
		# AB = null
		# B = null
		# repo.add root1 # A
		# .then (result) ->
		# 	A = result
		# 	child1.parentId = A
		# 	repo.add child1 # A.A
		# .then (result) ->
		# 	child2.parentId = A
		# 	repo.add child2 # A.B
		# .then (result) ->
		# 	AB = result
		# 	child4.parentId = AB
		# 	repo.add child4 # A.B.A
		# .then (result) ->
		# 	child5.parentId = AB
		# 	repo.add child5 # A.B.B
		# .then -> repo.add root2 # B
		# .then (result) ->
		# 	B = result
		# 	child3.parentId = B
		# 	repo.add child3 # B.A
		# .then -> repo.add rootC # C
		# .then -> repo.add rootD # D
		# .then (result) ->
		# 	D = result
		# 	childD.parentId = D
		# 	repo.add childD # D.A
		# .then -> done()
		# .catch done
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

	it 'removes statement', (done) ->

		repo.remove 10
		.then (ids) ->
			console.info 'removed', ids
		.then -> done()
		.catch done
		return

