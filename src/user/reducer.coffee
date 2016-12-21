update = require 'react-addons-update'
{LOGOUT} = require './actionTypes'

module.exports =

	user: (state = {}, action) ->

		switch action.type

		# 	when t.LOGIN_SUCCESS
		# 		update state, $isLogged: yes

			when LOGOUT
				{}

			else
				state

