fetch = require 'isomorphic-fetch'
{ADD_STATEMENT} = require '../statements/actionTypes'
{SYNC_REMOTE_END, STATEMENT_LOADING_END} = require '../layout/actionTypes'
{
	SYNC_REQUEST
	SYNC_STATEMENT_SUCCESS
	SYNC_STATEMENT_FAIL
	SAVE_STATE
	SYNC_STATE_HYDRATE
} = require './actionTypes'
idb = require '../lib/idb'
{getMine} = require '../statements/actions'

sync = ->
	_insertStatementToServer = (statement) ->
		fetch '/api/0/statements',
			method: 'post'
			credentials: 'same-origin'
			headers:
				'Accept': 'application/json',
				'Content-Type': 'application/json'
			body: JSON.stringify statement
		.then (response) -> response.json response

	_updateStatementToServer = (statement) ->
		fetch '/api/0/statements',
			method: 'put'
			credentials: 'same-origin'
			headers:
				'Accept': 'application/json',
				'Content-Type': 'application/json'
			body: JSON.stringify statement
		.then (response) -> response.json response

	_hydrate = ->
		fetch '/api/0/statements/mine',
			credentials: 'same-origin'
			headers:
				'Accept': 'application/json',
				'Content-Type': 'application/json'
		.then (response) -> response.json response

	sync: (dispatch, action, state) ->
		if action.type is SYNC_REQUEST
			return unless state.user.id
			return unless action = state.sync.slice(0, 1)[0]
			switch action.type
				when ADD_STATEMENT
					statement = action.data
					_insertStatementToServer statement
					.then ({error, id}) ->
						return dispatch type: SYNC_STATEMENT_FAIL if error
						dispatch type: SYNC_STATEMENT_SUCCESS, oldId: statement.id, newId: id
						dispatch type: SAVE_STATE
						dispatch type: SYNC_REQUEST
						return
		if action.type is SAVE_STATE
			{statements, statementsTree, user, sync} = state
			storeState = {statements, statementsTree, user, sync}
			storeState.layout = Object.assign {}, statements: {}, drawer: {} # nechci layout v SW, ale on tam zapisuje...
			idb.insert 'state', storeState
		if action.type is SYNC_STATE_HYDRATE
			getMine()(dispatch)
			.then ->
				dispatch type: STATEMENT_LOADING_END

		return


module.exports = sync()
