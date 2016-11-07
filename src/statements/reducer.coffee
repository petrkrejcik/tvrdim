update = require 'react-addons-update'
t = require './actionTypes'


module.exports =

	statement: (state = {}, action) ->
		switch action.type
			# when t.ADD_REQUEST
			# 	console.info 'action', t.ADD_REQUEST, action
			# 	key = if action.isPos then 'childrenPos' else 'childrenNeg'

			# 	# {text, isPos} = action
			# 	# newStatement = {text, isPos}
			# 	newState = update state, $merge: action
			# 	newState

			when t.ADD_SUCCESS
				update state, $merge: action.statement

			when t.GET_SUCCESS
				statements = {}
				statements[statement.id] = statement for statement in action.statements
				update state, $merge: statements

			when t.ADD_CHILD
				statement = state[action.parentId]
				if action.isPos
					arr = statement.childrenPos
				else
					arr = statement.childrenNeg
				arr.unshift action.childId
				update state, "#{action.parentId}": $set: statement

			else
				state

