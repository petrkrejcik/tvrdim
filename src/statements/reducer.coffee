update = require 'react-addons-update'
mock = require './mock'
t = require './actionTypes'


module.exports =

	statement: (state = mock.createDefault(), action) ->
		switch action.type
			when t.ADD
				console.info 'add action', action
				key = if action.isPos then 'childrenPos' else 'childrenNeg'
				changed = {}
				i = null
				for statement, i in state.statements
					break if statement.id is action.statementId
				return state unless i?


				changed[key] = $push: mock.create action.text, [action.statementId]
				newState = update state, statements: $push: [action.statementId]
				state
			when 'DECREMENT'
				state--
			else
				state

