update = require 'react-addons-update'
l = require './actionTypes'
{ANIMATION_START, ANIMATION_END} = require '../util/consts'

defaultState =
	statements:
		sort:
			root: []
		opened: null # => openedId
		openedTop: null
		animationOpen: null
	drawer:
		isOpened: no


module.exports =

	layout: (state = defaultState, action) ->
		switch action.type

			when l.STATEMENT_ADD_SUCCESS
				# TODO hide loader
				state

			when l.STATEMENT_OPEN
				console.warn 'TODO: use STATEMENT_OPEN_START'
				state

			when l.STATEMENT_OPEN_INIT
				{id} = action.statement
				{top} = action
				newState = update state, statements: opened: $set: id
				newState = update newState, statements: openedTop: $set: top
				update newState, statements: animationOpen: $set: null

			when l.STATEMENT_OPEN_START
				update state, statements: animationOpen: $set: ANIMATION_START

			when l.STATEMENT_OPEN_END
				newState = update state, statements: animationOpen: $set: ANIMATION_END
				update newState, statements: openedTop: $set: null

			when l.STATEMENT_OPEN_ROOT
				update state, statements: opened: $set: null

			when l.DRAWER_OPEN
				update state, drawer: isOpened: $set: yes

			else
				state
