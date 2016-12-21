update = require 'react-addons-update'
l = require './actionTypes'
{SYNC_STATEMENT_SUCCESS} = require '../sync/actionTypes'

defaultState =
	statements:
		opened: null
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

			when SYNC_STATEMENT_SUCCESS
				{oldId, newId} = action
				newState = state
				if state.statements.opened is oldId
					newState = update state, statements: opened: $set: newId
				newState

			else
				state

