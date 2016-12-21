update = require 'react-addons-update'
{STATEMENT_ADD_REQUEST} = require '../statements/actionTypes'

module.exports =

	sync: (state = [], action) ->

		switch action.type

			when STATEMENT_ADD_REQUEST
				update state, $push [action.action]

			else
				state

