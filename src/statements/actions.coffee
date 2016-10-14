module.exports =

	addStatement: (parentId, text, isPos) ->
		type: 'ADD_STATEMENT'
		isPos: isPos
		text: text
		parentId: parentId