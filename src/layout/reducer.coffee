update = require 'react-addons-update'
l = require './actionTypes'
{ANIMATION_INIT, ANIMATION_START, ANIMATION_END} = require '../util/consts'

defaultState =
	statements:
		sort:
			root: []
		opened: 'root' # => openedId
		openingId: null
		openedTop: null
		firstOffset:
			top: 0
			left: 0
			height: 0
			topViewport: 0
		animationOpenChild: null
		animationOpenParent: null
		isOpening: no
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
				newState = update state, statements: openingId: $set: id
				newState = update newState, statements: openedTop: $set: top
				newState = update newState, statements: isOpening: $set: yes
				newState = update newState, statements: animationOpenChild: $set: ANIMATION_INIT

			when l.STATEMENT_OPEN_START
				update state, statements: animationOpenChild: $set: ANIMATION_START

			when l.STATEMENT_OPEN_END
				newState = update state, statements: animationOpenChild: $set: ANIMATION_END
				newState = update newState, statements: opened: $set: newState.statements.openingId
				newState = update newState, statements: isOpening: $set: no
				newState = update newState, statements: openingId: $set: null
				# update newState, statements: openedTop: $set: null

			when l.STATEMENT_OPEN_ROOT_INIT
				newState = update state, statements: openingId: $set: 'root'
				newState = update newState, statements: isOpening: $set: yes
				update newState, statements: animationOpenParent: $set: ANIMATION_INIT

			when l.STATEMENT_OPEN_ROOT_START
				update state, statements: animationOpenParent: $set: ANIMATION_START

			when l.STATEMENT_OPEN_ROOT_END
				newState = update state, statements: openingId: $set: null
				newState = update newState, statements: animationOpenParent: $set: ANIMATION_END
				newState = update newState, statements: isOpening: $set: no
				update newState, statements: opened: $set: 'root'

			when l.STATEMENT_STORE_FIRST_TOP_OFFSET
				update state, statements: firstOffset: $set: action.offset

			when l.DRAWER_OPEN
				update state, drawer: isOpened: $set: yes

			else
				state
