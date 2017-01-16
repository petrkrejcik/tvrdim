{LOGOUT} = require './actionTypes'
{SYNC_STATE_LOCAL} = require '../sync/actionTypes'

module.exports =

	logout: ->
		(dispatch) ->
			fetch '/logout', credentials: 'same-origin'
			dispatch type: LOGOUT
			dispatch type: SYNC_STATE_LOCAL
