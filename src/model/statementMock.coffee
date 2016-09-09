lastId = 0
create = (text, childrenPos = [], childrenNeg = []) ->
	id = lastId++
	id: id
	key: id
	text: text
	childrenPos: childrenPos
	childrenNeg: childrenNeg

module.exports = [
	create 'Behat rano je zdravejsi', [create 'Nastartuje se ti mozek'], [create 'Jses unaveny uz od rana']
	create 'Kafe nemas pit vecer'
	create 'Vzdy mluvit pravdu'
]
