update = require 'react-addons-update'
{ADD_STATEMENT, UPDATE_STATEMENT, UPDATE_STATEMENT_ID} = require '../statements/actionTypes'
{SYNC_SUCCESS, SYNC_FAIL} = require './actionTypes'

module.exports =

	sync: (state = [], action) ->

		switch action.type

			when ADD_STATEMENT
				update state, $push: [action]

			when UPDATE_STATEMENT
				update state, $push: [action]

			when SYNC_SUCCESS
				update state, $splice: [[0, 1]]

			when SYNC_FAIL
				console.error 'SYNC_FAIL'
				update state, $set: []

			when UPDATE_STATEMENT_ID
				newState = state
				for queued, index in newState
					continue unless queued.type in [ADD_STATEMENT, UPDATE_STATEMENT]
					statement = Object.assign {}, queued.data # copy current statement
					if isOldId = statement.id is action.oldId
						statement.id = action.newId
					if statement.ancestor and isOldAncestor = statement.ancestor is action.oldId
						statement.ancestor = action.newId
					newAction =
						type: queued.type
						data: statement
					newState = update newState, $splice: [[index, 1, newAction]]
				newState

			else
				state

