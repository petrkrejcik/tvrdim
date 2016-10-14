lastId = 0

module.exports =
	create: (text, childrenPos = [], childrenNeg = []) ->
		id = lastId++
		id: id
		key: id
		text: text
		childrenPos: childrenPos
		childrenNeg: childrenNeg

	createDefault: ->
		[
			@create 'Behat rano je zdravejsi', [@create 'Nastartuje se ti mozek'], [@create 'Jses unaveny uz od rana']
			@create 'Kafe nemas pit vecer'
			@create 'Vzdy mluvit pravdu'
		]
