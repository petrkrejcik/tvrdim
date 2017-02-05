expect = require('chai').expect
{getRoot} = require '../src/statements/util'


describe 'Statement utils', ->

	it 'finds root', (done) ->
		rootId = getRoot '6', statementsTree
		expect(rootId).to.be.equal '2'
		done()




statements =
	'2':
		id: '2'
		text: 'A'
		createdTime: '2017-02-03T10:01:59.518Z'
		score: 0
	'3':
		ancestor: '2'
		id: '3'
		agree: false
		text: 'A.A'
		createdTime: '2017-02-03T10:01:59.530Z'
	'4':
		ancestor: '2'
		id: '4'
		agree: true
		text: 'A.B'
		createdTime: '2017-02-03T10:01:59.534Z'
		score: 0
	'5':
		ancestor: '4'
		id: '5'
		agree: false
		text: 'A.B.A'
		createdTime: '2017-02-03T10:01:59.537Z'
	'6':
		ancestor: '4'
		id: '6'
		agree: true
		text: 'A.B.B'
		createdTime: '2017-02-03T10:01:59.543Z'
	'7':
		id: '7'
		text: 'B'
		createdTime: '2017-02-03T10:01:59.546Z'
		score: -1
	'8':
		ancestor: '7'
		id: '8'
		agree: false
		text: 'B.A'
		createdTime: '2017-02-03T10:01:59.550Z'
	'9':
		id: '9'
		text: 'C'
		createdTime: '2017-02-03T10:01:59.553Z'
		score: 0
	'10':
		id: '10'
		text: 'D'
		createdTime: '2017-02-03T10:01:59.559Z'
		score: 0
	'11':
		ancestor: '10'
		id: '11'
		agree: true
		text: 'D.A'
		createdTime: '2017-02-03T10:01:59.562Z'
	'12':
		ancestor: '10'
		id: '12'
		agree: true
		text: 'D.B'
		createdTime: '2017-02-03T10:01:59.567Z'
		score: -1
	'13':
		ancestor: '12'
		id: '13'
		agree: false
		text: 'D.B.A'
		createdTime: '2017-02-03T10:01:59.571Z'
	'14':
		ancestor: '10'
		id: '14'
		agree: false
		text: 'D.C'
		createdTime: '2017-02-03T10:01:59.575Z'

statementsTree =
	'2': [
		'3'
		'4'
	]
	'4': [
		'5'
		'6'
	]
	'7': [ '8' ]
	'10': [
		'11'
		'12'
		'14'
	]
	'12': [ '13' ]
	root: [
		'2'
		'7'
		'9'
		'10'
	]
