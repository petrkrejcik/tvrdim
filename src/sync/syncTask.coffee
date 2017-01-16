fetch = require 'isomorphic-fetch'
{ADD_STATEMENT} = require '../statements/actionTypes'
{SYNC_REMOTE_END} = require '../layout/actionTypes'
{
	SYNC_STATEMENT_REQUEST
	SYNC_STATEMENT_SUCCESS
	SYNC_STATEMENT_FAIL
	SYNC_STATE_LOCAL
	SYNC_STATE_HYDRATE
} = require './actionTypes'
idb = require '../lib/idb'

sync = ->
	_statementToServer = (statement) ->
		fetch '/api/0/statements',
			method: 'post'
			credentials: 'same-origin'
			headers:
				'Accept': 'application/json',
				'Content-Type': 'application/json'
			body: JSON.stringify statement
		.then (response) -> response.json response

	_hydrate = ->
		fetch '/api/0/state',
			credentials: 'same-origin'
			headers:
				'Accept': 'application/json',
				'Content-Type': 'application/json'
		.then (response) -> response.json response

	sync: (dispatch, action, state) ->
		if action.type is SYNC_STATEMENT_REQUEST
			return unless state.user.id
			return unless statement = state.sync.slice(0, 1)[0]
			return unless oldId = Object.keys(statement)[0]
			_statementToServer statement[oldId]
			.then ({error, id}) ->
				return dispatch type: SYNC_STATEMENT_FAIL if error
				dispatch type: SYNC_STATEMENT_SUCCESS, oldId: oldId, newId: id
		if action.type is SYNC_STATE_LOCAL
			idb.insert 'state', state
		if action.type is SYNC_STATE_HYDRATE
			_hydrate()
			.then (newState) ->
				console.info 'newState', newState
				# dispatch type: ADD_STATEMENT, statement: "#{id}": statement
				# dispatch {type: st.ADD, statement}
				# dispatch SYNC_STATE_LOCAL
		return


module.exports = sync()
