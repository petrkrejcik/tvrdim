update = require 'react-addons-update'
l = require './actionTypes'

defaultState =
	statements:
		sort:
			root: []
		opened:
			pos: []
			neg: []


module.exports =


	layout: (state = defaultState, action) ->
		switch action.type

			when l.STATEMENTS_COLLAPSE
				id = action.statementId
				key = if action.isPos then 'pos' else 'neg'
				current = state.statements.opened[key]
				if (index = current.indexOf id) > -1
					current.splice index, 1
				else
					current.push id

				update state, statements: opened: "#{key}": $set: current

			when l.STATEMENTS_SORT_ROOT
				update state, statements: sort: root: $set: (statement.id for statement in action.statements)

			when l.STATEMENTS_SORT_ROOT_ADD
				update state, statements: sort: root: $unshift: [action.id]

			else
				state

