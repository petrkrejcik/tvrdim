{LOGOUT} = require './actionTypes'
{SAVE_STATE} = require '../sync/actionTypes'

module.exports =

	logout: ->
		(dispatch, getState) ->
			privateStatements = []
			for id, statement of getState().statements when statement.isPrivate
				privateStatements.push id
			fetch '/logout', credentials: 'same-origin'
			dispatch {type: LOGOUT, privateStatements}
			dispatch type: SAVE_STATE
