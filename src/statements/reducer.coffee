update = require 'react-addons-update'
{GET_SUCCESS, ADD_STATEMENT, UPDATE_STATEMENT, UPDATE_STATEMENT_ID, ADD_FAILURE, COUNT_SCORE, GET_FAILURE} = require './actionTypes'
{countScore} = require './util'
{LOGOUT} = require '../user/actionTypes'


module.exports =

	statement: (state = {}, action) ->

		_countParentScore = (ancestor, oldState, newState) ->
			parent = oldState[ancestor]
			return newState unless parent
			if parent.score isnt newState[ancestor].score
				newState = update newState, "#{ancestor}": $set: newState[ancestor]
			if parent.ancestor
				_countParentScore parent.ancestor, oldState, newState
			else
				newState

		switch action.type

			when GET_SUCCESS
				update state, $merge: action.statements

			when ADD_STATEMENT
				statement = action.data
				update state, $merge: "#{statement.id}": statement

			when UPDATE_STATEMENT
				{id, text, isPrivate} = action.data
				newState = state
				newState = update newState, "#{id}": text: $set: text if text
				if isPrivate
					newState = update newState, "#{id}": isPrivate: $set: yes
				else
					delete newState[id].isPrivate
				newState

			when ADD_FAILURE
				{error} = action
				console.info 'adding statements failure:', error
				state

			when COUNT_SCORE
				ancestor = 'root' unless ancestor = action.ancestor
				newState = _countParentScore ancestor, state, countScore state
				newState

			when GET_FAILURE
				{error} = action
				console.info 'failure for getting statements:', error
				state

			when UPDATE_STATEMENT_ID
				{oldId, newId} = action
				newState = state
				for id, statement of state
					if id is oldId
						newStatement = Object.assign {}, statement
						newStatement.id = newId
						newState = update newState, "#{newId}": $set: newStatement
					if statement.ancestor is oldId
						newState = update newState, "#{id}": ancestor: $set: newId
				delete newState[oldId] # how else?
				newState

			when LOGOUT
				changed = []
				for id, statement of state
					continue if not statement.isMine
					newStatement = Object.assign {}, statement
					delete newStatement.isMine
					changed.push newStatement
				newState = state
				for change in changed
					newState = update newState, "#{change.id}": $set: change
				for id, statement of state when statement.isPrivate
					delete newState[id] # how else? use immutable.js
				newState
			else
				state

