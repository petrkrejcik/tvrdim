update = require 'react-addons-update'
{ADD_STATEMENT} = require '../statements/actionTypes'
{SYNC_STATEMENT_SUCCESS} = require './actionTypes'

module.exports =

	sync: (state = [], action) ->

		switch action.type

			when ADD_STATEMENT
				update state, $push: [action.statement]

			when SYNC_STATEMENT_SUCCESS
				statement = state.slice(0, 1)[0] ? {}
				id = Object.keys(statement)[0]
				unless id
					console.error "Sync error - first item in sync array was not synchronised. '#{action.oldId}'"
					return {} # reset sync queue to not sync again the same
				newState = update state, $splice: [[0, 1]]
				for obj, index in newState
					objId = Object.keys(obj)[0]
					continue unless oldObj = obj[objId]
					continue unless oldObj.ancestor
					continue unless oldObj.ancestor is action.oldId
					newObj = Object.assign {}, oldObj
					newObj.ancestor = action.newId
					newState = update newState, $splice: [[index, 1, "#{newObj.id}": newObj]]
				newState

			else
				state

