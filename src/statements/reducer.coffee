update = require 'react-addons-update'
t = require './actionTypes'
{countScore} = require './util'


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

			when t.COUNT_SCORE
				parentId = 'root' unless parentId = action.parentId
				newState = _countParentScore parentId, state, countScore state
				newState

			else
				state

