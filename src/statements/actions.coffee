{
	ADD_STATEMENT
	UPDATE_STATEMENT
	GET_SUCCESS
	COUNT_SCORE
	GET_REQUEST
	GET_FAILURE
	ADD_FAILURE
} = require './actionTypes'
{SYNC_REQUEST, SAVE_STATE} = require '../sync/actionTypes'
{STATEMENT_OPEN, STATEMENT_MENU_CLOSE} = require '../layout/actionTypes'
st = require '../statementsTree/actionTypes'
fetch = require 'isomorphic-fetch'

actions = ->

	# _filterBy = (dispatch, filter) ->
	# 	dispatch type: GET_REQUEST # to by mel vypalit nekdo jinej, na miste, odkud se to vola
	# 	params = encodeURIComponent JSON.stringify filter
	# 	fetch "/api/0/statements?q=#{params}"
	# 	.then (response) -> response.json response

	addStatement: (ancestor, text, agree, userId, isPrivate) ->
		(dispatch) ->
			isMine = yes
			id = Math.random().toString(36).substring(2)
			statement = {id, ancestor, text, agree, isMine} # is id necessary for storing into DB?
			statement.isPrivate = isPrivate if isPrivate
			dispatch type: ADD_STATEMENT, data: statement
			dispatch {type: st.ADD, statement}
			dispatch {type: COUNT_SCORE, ancestor}
			dispatch {type: STATEMENT_OPEN, statement} unless statement.ancestor
			dispatch type: SAVE_STATE
			dispatch type: SYNC_REQUEST
			return

	update: ({id, text, isPrivate, ancestor}) ->
		(dispatch) ->
			data = {id}
			data.text = text if text
			data.isPrivate = isPrivate if isPrivate?
			dispatch {type: UPDATE_STATEMENT, data}
			dispatch {type: STATEMENT_MENU_CLOSE}
			dispatch type: SAVE_STATE
			dispatch type: SYNC_REQUEST
			return

	getAll: ->
		(dispatch) ->
			dispatch type: GET_REQUEST # to by mel vypalit nekdo jinej, na miste, odkud se to vola
			fetch '/api/0/statements'
			.then (response) -> response.json response
			.then ({entities, tree}) ->
				Object.keys(entities).map (id) -> tree[id] = [] unless tree[id]
				dispatch type: GET_SUCCESS, statements: entities
				dispatch type: st.UPDATE, tree: tree
			return

	# getDirectChildren: (parentIds) ->
	# 	# not used
	# 	(dispatch) ->
	# 		_filterBy dispatch, {parentIds}
	# 		.then ({entities, tree}) ->
	# 			Object.keys(entities).map (id) -> tree[id] = [] unless tree[id]
	# 			dispatch type: GET_SUCCESS, statements: entities
	# 			dispatch type: st.UPDATE, tree: tree
	# 		return

	getByIds: (ids) ->
		(dispatch) ->
			_filterBy dispatch, {ids}
			.then ({data}) ->
				dispatch type: GET_SUCCESS, statements: data
			return

	remove: (id, ancestor) ->
		parent = ''
		parent = "/#{ancestor}" if ancestor
		(dispatch) ->
			fetch "/api/0/statements/#{id}#{parent}",
				method: 'delete'
				credentials: 'same-origin'
			.then (response) -> response.json response
			.then (response) ->
				console.info 'removed?', response
				# return dispatch {type: GET_FAILURE, error} if error
				# Object.keys(entities).map (id) -> tree[id] = [] unless tree[id]
				# dispatch type: GET_SUCCESS, statements: entities
				# dispatch type: st.UPDATE, tree: tree
				# return
			return

	getMine: ->
		(dispatch) ->
			fetch '/api/0/statements/mine', credentials: 'same-origin'
			.then (response) -> response.json response
			.then ({error, entities, tree}) ->
				return dispatch {type: GET_FAILURE, error} if error
				Object.keys(entities).map (id) -> tree[id] = [] unless tree[id]
				dispatch type: GET_SUCCESS, statements: entities
				dispatch type: st.UPDATE, tree: tree
				dispatch type: SAVE_STATE
				return

module.exports = actions()
