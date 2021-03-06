update = require 'react-addons-update'
a = require './actionTypes'
{UPDATE_STATEMENT_ID} = require '../statements/actionTypes'
{LOGOUT} = require '../user/actionTypes'

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
						continue if id in newState[keyId]
						newState = update newState, "#{keyId}": $push: [id]
				newState

			when a.ADD
				ancestor = 'root' unless ancestor = action.statement.ancestor
				if state[ancestor]
					newState = update state, "#{ancestor}": $unshift: [action.statement.id]
				else
					newState = update state, "#{ancestor}": $set: [action.statement.id]
				update newState, "#{action.statement.id}": $set: []

			when UPDATE_STATEMENT_ID
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

			when LOGOUT
				newState = state
				for id, childrenIds of state
					for privateId in action.privateStatements
						index = childrenIds.indexOf privateId
						continue if index is -1
						newState = update newState, "#{id}": $splice: [[index, 1]]
					if id is privateId
						delete newState[id] # how else? use immutable.js
				newState

			else
				state

