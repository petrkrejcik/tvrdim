update = require 'react-addons-update'
l = require './actionTypes'
{UPDATE_STATEMENT_ID} = require '../statements/actionTypes'
{STATEMENT_LOADING_END, STATEMENT_MENU_OPEN, STATEMENT_MENU_CLOSE} = require './actionTypes'

defaultState =
	statements:
		opened: null
		isLoading: no
		menuOpened: null
	drawer:
		isOpened: no

module.exports =


	layout: (state = defaultState, action) ->
		switch action.type

			when l.STATEMENT_OPEN
				update state, statements: opened: $set: action.id

			when l.STATEMENT_OPEN_ROOT
				update state, statements: opened: $set: null

			when l.DRAWER_OPEN
				update state, drawer: isOpened: $set: yes

			when l.DRAWER_CLOSE
				update state, drawer: isOpened: $set: no

			when UPDATE_STATEMENT_ID
				{oldId, newId} = action
				newState = state
				if state.statements.opened is oldId
					newState = update state, statements: opened: $set: newId
				newState

			when STATEMENT_LOADING_END
				update state, statements: isLoading: $set: no

			when STATEMENT_MENU_OPEN
				update state, statements: menuOpened: $set: action.data.statementId

			when STATEMENT_MENU_CLOSE
				update state, statements: menuOpened: $set: no

			else
				state

