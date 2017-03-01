update = require 'react-addons-update'
l = require './actionTypes'
{STATEMENT_LOADING_END, STATEMENT_MENU_OPEN, STATEMENT_MENU_CLOSE} = require './actionTypes'

defaultState =
	statements:
		isLoading: no
		menuOpened: null
	drawer:
		isOpened: no

module.exports =


	layout: (state = defaultState, action) ->
		switch action.type

			when l.DRAWER_OPEN
				update state, drawer: isOpened: $set: yes

			when l.DRAWER_CLOSE
				update state, drawer: isOpened: $set: no

			when STATEMENT_LOADING_END
				update state, statements: isLoading: $set: no

			when STATEMENT_MENU_OPEN
				update state, statements: menuOpened: $set: action.data.statementId

			when STATEMENT_MENU_CLOSE
				update state, statements: menuOpened: $set: no

			else
				state

