update = require 'react-addons-update'
a = require './actionTypes'

defaultState =
	root: []


module.exports =


	statementsTree: (state = defaultState, action) ->
		switch action.type

			when a.UPDATE
				# nemel by se updatovat celej strom, jen konkretni klic
				update state, $set: action.tree

			else
				state

