t = require './actionTypes'

module.exports =

	addStatement: (parentId, text, isPos) ->
		type: t.ADD
		isPos: isPos
		text: text
		parentId: parentId
