update = require 'react-addons-update'
t = require './actionTypes'
{countScore} = require './util'
{LOGOUT} = require '../user/actionTypes'


module.exports =

	statement: (state = {}, action) ->

		_countParentScore = (parentId, oldState, newState) ->
			parent = oldState[parentId]
			return newState unless parent
			if parent.score isnt newState[parentId].score
				newState = update newState, "#{parentId}": $set: newState[parentId]
			if parent.ancestor
				_countParentScore parent.ancestor, oldState, newState
			else
				newState

		switch action.type

			when t.GET_SUCCESS
				update state, $merge: action.statements

			when t.ADD
				update state, $merge: action.statement

			when t.ADD_FAILURE
				{error} = action
				console.info 'adding statements failure:', error
				state

			when t.COUNT_SCORE
				parentId = 'root' unless parentId = action.parentId
				newState = _countParentScore parentId, state, countScore state
				newState

			when t.GET_FAILURE
				{error} = action
				console.info 'failure for getting statements:', error
				state

			when LOGOUT
				changed = []
				for id, statement of state
					continue unless statement.isMine
					newStatement = Object.assign {}, statement
					delete newStatement.isMine
					changed.push newStatement
				newState = state
				for change in changed
					newState = update newState, "#{change.id}": $set: change
				newState
			else
				state

