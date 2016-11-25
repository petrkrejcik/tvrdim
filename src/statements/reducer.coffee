update = require 'react-addons-update'
t = require './actionTypes'


module.exports =

	statement: (state = {}, action) ->
		switch action.type

			when t.GET_SUCCESS
				update state, $merge: action.statements

			when t.ADD
				update state, $merge: action.statement

			else
				state

