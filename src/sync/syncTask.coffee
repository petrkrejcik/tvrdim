fetch = require 'isomorphic-fetch'
{ADD_STATEMENT} = require '../statements/actionTypes'
{SYNC_START, SYNC_END} = require '../layout/actionTypes'
{SYNC_STATEMENT_SUCCESS} = require './actionTypes'

syncable = [
	ADD_STATEMENT
]

sync = ->
	_storeOnServer = (statement) ->
		fetch '/api/0/statements',
			method: 'post'
			credentials: 'same-origin'
			headers:
				'Accept': 'application/json',
				'Content-Type': 'application/json'
			body: JSON.stringify statement
		.then (response) -> response.json response

	sync: (dispatch, action, state) ->
		return unless state.user.id
		return unless action.type in syncable
		if action.type is ADD_STATEMENT
			return unless statement = state.sync.slice(0, 1)[0]
			return unless oldId = Object.keys(statement)[0]
			dispatch type: SYNC_START
			_storeOnServer statement[oldId]
			.then ({error, id}) ->
				return dispatch type: SYNC_END if error
				dispatch type: SYNC_STATEMENT_SUCCESS, oldId: oldId, newId: id
				dispatch type: SYNC_END
		yes


module.exports = sync()
