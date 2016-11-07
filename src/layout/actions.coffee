l = require './actionTypes'

module.exports =

	toggleVisibility: (statementId, isPos) ->
		type: l.STATEMENTS_COLLAPSE
		statementId: statementId
		isPos: isPos
