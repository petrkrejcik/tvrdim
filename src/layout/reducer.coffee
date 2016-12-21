update = require 'react-addons-update'
l = require './actionTypes'

defaultState =
	statements:
		sort:
			root: []
		opened: null
	drawer:
		isOpened: no

module.exports =


	layout: (state = defaultState, action) ->
		switch action.type

			when l.STATEMENT_OPEN
				{id} = action.statement
				update state, statements: opened: $set: id

			when l.STATEMENT_OPEN_ROOT
				update state, statements: opened: $set: null

			when l.DRAWER_OPEN
				update state, drawer: isOpened: $set: yes

			when l.DRAWER_CLOSE
				update state, drawer: isOpened: $set: no

			else
				state

