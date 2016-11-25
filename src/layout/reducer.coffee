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

			when l.STATEMENT_ADD_SUCCESS
				# TODO hide loader
				state

			when l.STATEMENT_OPEN
				id = action.statement.id
				key = 'pos' # TODO
				current = state.statements.opened[key]
				current.push id
				update state, statements: opened: "#{key}": $set: current

			else
				state

