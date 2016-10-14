update = require 'react-addons-update'

defaultState =
	statements:
		openedPos: []
		openedNeg: []


module.exports =


	layout: (state = defaultState, action) ->
		switch action.type
			when 'TOGGLE_STATEMENT_CHILD_VISIBILITY'
				changed = {}
				key = if action.isPos then 'openedPos' else 'openedNeg'
				if action.statementId in state.statements[key]
					changed[key] = $set: state.statements[key].filter (id) -> id isnt action.statementId
					newState = update state, statements: changed
				else
					changed[key] = $push: [action.statementId]
					newState = update state, statements: changed
				newState
			else
				state

