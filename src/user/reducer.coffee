update = require 'react-addons-update'
{LOGOUT, LOGIN_SUCCESS} = require './actionTypes'

module.exports =

	user: (state = {}, action) ->

		switch action.type

			when LOGIN_SUCCESS
				update state, $set: action.user

			when LOGOUT
				{}

			else
				state

