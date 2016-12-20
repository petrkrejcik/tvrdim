{LOGOUT} = require './actionTypes'

module.exports =

	logout: ->
		fetch '/logout', credentials: 'same-origin'
		{
			type: LOGOUT
		}
