update = require 'react-addons-update'
l = require './actionTypes'

defaultState =
	statements:
		sort:
			root: []
		opened:
			agree: []
			disagree: []


module.exports =


	layout: (state = defaultState, action) ->
		switch action.type

			when l.STATEMENT_ADD_SUCCESS
				# TODO hide loader
				state

			when l.STATEMENT_OPEN
				{id, agree} = action.statement
				key = if agree then 'agree' else 'disagree'
				current = state.statements.opened[key]
				current.push id
				update state, statements: opened: "#{key}": $set: current

			when l.STATEMENT_CLOSE
				{id, agree} = action.statement
				key = if agree then 'agree' else 'disagree'
				current = state.statements.opened[key]
				index = current.indexOf id
				update state, statements: opened: "#{key}": $splice: [[index, 1]]

			else
				state

