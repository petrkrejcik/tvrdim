update = require 'react-addons-update'
a = require './actionTypes'
{SYNC_STATEMENT_SUCCESS} = require '../sync/actionTypes'

defaultState =
	root: []


module.exports =


	statementsTree: (state = defaultState, action) ->
		switch action.type

			when a.UPDATE
				newState = state
				for keyId, ids of action.tree
					unless state[keyId]
						newState = update state, $merge: "#{keyId}": []
					for id in ids
						continue if id in state[keyId]
						newState = update state, "#{keyId}": $push: [id]
				newState

			when a.ADD
				ancestor = 'root' unless ancestor = action.statement.ancestor
				if state[ancestor]
					newState = update state, "#{ancestor}": $unshift: [action.statement.id]
				else
					newState = update state, "#{ancestor}": $set: [action.statement.id]
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

