update = require 'react-addons-update'
a = require './actionTypes'

defaultState =
	root: []


module.exports =


	statementsTree: (state = defaultState, action) ->
		switch action.type

			when a.UPDATE
				update state, $merge: action.tree

			when a.ADD
				newState = update state, "#{action.statement.parentId}": $push: [action.statement.id]
				update newState, "#{action.statement.id}": $set: []

			else
				state

