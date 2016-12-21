update = require 'react-addons-update'
a = require './actionTypes'
{SYNC_STATEMENT_SUCCESS} = require '../sync/actionTypes'

defaultState =
	root: []


module.exports =


	statementsTree: (state = defaultState, action) ->
		switch action.type

			when a.UPDATE
				update state, $merge: action.tree

			when a.ADD
				parentId = 'root' unless parentId = action.statement.parentId
				newState = update state, "#{parentId}": $unshift: [action.statement.id]
				update newState, "#{action.statement.id}": $set: []

			when SYNC_STATEMENT_SUCCESS
				{oldId, newId} = action
				newState = state
				for id, childrenIds of state
					if id is oldId
						newState = update newState, "#{newId}": $set: childrenIds
					if oldId in childrenIds
						index = childrenIds.indexOf oldId
						newState = update newState, "#{id}": $splice: [[index, 1, newId]]
				delete newState[oldId] # how else?
				newState

			else
				state

