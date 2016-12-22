{ADD_STATEMENT, GET_SUCCESS, COUNT_SCORE, GET_REQUEST, GET_FAILURE, ADD_FAILURE} = require './actionTypes'
{SYNC_STATEMENT_REQUEST, SYNC_STATE_LOCAL} = require '../sync/actionTypes'
l = require '../layout/actionTypes'
st = require '../statementsTree/actionTypes'
fetch = require 'isomorphic-fetch'

actions = ->

	# _filterBy = (dispatch, filter) ->
	# 	dispatch type: GET_REQUEST # to by mel vypalit nekdo jinej, na miste, odkud se to vola
	# 	params = encodeURIComponent JSON.stringify filter
	# 	fetch "/api/0/statements?q=#{params}"
	# 	.then (response) -> response.json response

	addStatement: (ancestor, text, agree, userId) ->
		(dispatch) ->
			isMine = yes
			id = Math.random().toString(36).substring(2)
			statement = {id, ancestor, text, agree, isMine}
			dispatch type: ADD_STATEMENT, statement: "#{id}": statement
			dispatch type: SYNC_STATE_LOCAL
			dispatch {type: st.ADD, statement}
			dispatch {type: COUNT_SCORE, ancestor}
			dispatch {type: l.STATEMENT_OPEN, statement} unless statement.ancestor
			dispatch type: SYNC_STATEMENT_REQUEST
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
			dispatch type: GET_REQUEST # to by mel vypalit nekdo jinej, na miste, odkud se to vola
			fetch '/api/0/statements/mine', credentials: 'same-origin'
			.then (response) -> response.json response
			.then ({error, entities, tree}) ->
				return dispatch {type: GET_FAILURE, error} if error
				Object.keys(entities).map (id) -> tree[id] = [] unless tree[id]
				dispatch type: GET_SUCCESS, statements: entities
				dispatch type: st.UPDATE, tree: tree
				return
			return

module.exports = actions()
