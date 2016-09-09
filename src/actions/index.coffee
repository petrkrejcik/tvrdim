module.exports =

	toggleVisibility: (statementId, isPos) ->
		type: 'TOGGLE_STATEMENT_CHILD_VISIBILITY'
		statementId: statementId
		isPos: isPos