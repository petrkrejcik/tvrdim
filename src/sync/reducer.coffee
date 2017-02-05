update = require 'react-addons-update'
{ADD_STATEMENT} = require '../statements/actionTypes'
{SYNC_STATEMENT_SUCCESS} = require './actionTypes'

module.exports =

	sync: (state = [], action) ->

		switch action.type

			when ADD_STATEMENT
				update state, $push: [action]

			when SYNC_STATEMENT_SUCCESS
				queue = state.slice(0, 1)[0] ? {}
				unless queue.type is ADD_STATEMENT
					console.error "Sync error - first item in sync array was not synchronised. '#{action.oldId}'"
					return [] # reset sync queue to not sync again the same
				newState = update state, $splice: [[0, 1]]
				for queued, index in newState
					continue unless queued.type is ADD_STATEMENT
					statement = queued.data
					continue unless statement.ancestor
					continue unless statement.ancestor is action.oldId
					newStatement = Object.assign {}, statement
					newStatement.ancestor = action.newId
					newAction =
						type: ADD_STATEMENT
						data: newStatement
					newState = update newState, $splice: [[index, 1, newAction]]
				newState

			else
				state

