repo = require '../src/statements/repo'
hook = require '../test/before'

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
childDB =
	text: 'D.B'
	agree: yes
childDC =
	text: 'D.C'
	agree: no
childDBA =
	text: 'D.B.A'
	agree: no

run = ->
	return new Promise (resolve, reject) ->
		rootId = null
		A = null
		AB = null
		B = null
		D = null
		repo.add root1 # A
		.then (result) ->
			A = result
			child1.ancestor = A
			repo.add child1 # A.A
		.then (result) ->
			child2.ancestor = A
			repo.add child2 # A.B
		.then (result) ->
			AB = result
			child4.ancestor = AB
			repo.add child4 # A.B.A
		.then (result) ->
			child5.ancestor = AB
			repo.add child5 # A.B.B
		.then -> repo.add root2 # B
		.then (result) ->
			B = result
			child3.ancestor = B
			repo.add child3 # B.A
		.then -> repo.add rootC # C
		.then -> repo.add rootD # D
		.then (result) ->
			D = result
			childD.ancestor = D
			repo.add childD # D.A
		.then (result) ->
			childDB.ancestor = D
			repo.add childDB # D.B
		.then (result) ->
			childDBA.ancestor = result
			repo.add childDBA # D.B.A
		.then (result) ->
			childDC.ancestor = D
			repo.add childDC # D.C
		.then resolve
		.catch reject

hook()
.then run
.then -> repo.getAll()
.then (result) -> console.info result
.then -> process.exit 1
.catch -> process.exit 1
