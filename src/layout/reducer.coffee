update = require 'react-addons-update'
l = require './actionTypes'

defaultState =
	statements:
		sort:
			root: []
		opened: null

module.exports =


	layout: (state = defaultState, action) ->
		switch action.type

			when l.STATEMENT_ADD_SUCCESS
				# TODO hide loader
				state

			when l.STATEMENT_OPEN
				{id} = action.statement
				update state, statements: opened: $set: id

			when l.STATEMENT_OPEN_ROOT
				update state, statements: opened: $set: null

			else
				state

