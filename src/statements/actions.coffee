t = require './actionTypes'
l = require '../layout/actionTypes'
st = require '../statementsTree/actionTypes'
fetch = require 'isomorphic-fetch'

actions = ->

	_addStatementRequest = (parentId) ->
		type: l.STATEMENT_ADD_REQUEST
		parentId: parentId

	_addStatementSuccess = (statement) ->
		type: l.STATEMENT_ADD_SUCCESS
		statement: statement

	_getRoot = (dispatch) ->
		dispatch type: t.GET_REQUEST # to by mel vypalit nekdo jinej, na miste, odkud se to vola
		fetch '/api/0/statement/get'
		.then (response) -> response.json response

	_filterBy = (dispatch, filter) ->
		dispatch type: t.GET_REQUEST # to by mel vypalit nekdo jinej, na miste, odkud se to vola
		fetch '/api/0/statement/filter',
			method: 'post'
			headers:
				'Accept': 'application/json',
				'Content-Type': 'application/json'
			body: JSON.stringify filter
		.then (response) -> response.json response


	addStatement: (parentId, text, isPos) ->
		(dispatch) ->
			statement = {parentId, text, isPos}
			dispatch _addStatementRequest parentId
			fetch '/api/0/statement/add',
				method: 'post'
				headers:
					'Accept': 'application/json',
					'Content-Type': 'application/json'
				body: JSON.stringify statement
			.then (response) -> response.json response
			.then ({id}) ->
				if parentId
					dispatch type: t.ADD_CHILD, statement: "#{id}": {text, id}
					dispatch type: st.ADD_CHILD, statement: {parentId, id}
				else
					dispatch type: l.STATEMENTS_SORT_ROOT_ADD, id: id # TODO
				dispatch _addStatementSuccess "#{id}": {text, id}
			return

	getRoot: (filter) ->
		(dispatch) ->
			_getRoot dispatch
			.then ({entities, tree}) ->
				Object.keys(entities).map (id) -> tree[id] = [] unless tree[id]
				dispatch type: t.GET_SUCCESS, statements: entities
				dispatch type: st.UPDATE, tree: tree
			return


	getDirectChildren: (parentIds) ->
		(dispatch) ->
			_filterBy dispatch, {parentIds}
			.then ({entities, tree}) ->
				Object.keys(entities).map (id) -> tree[id] = [] unless tree[id]
				dispatch type: t.GET_SUCCESS, statements: entities
				dispatch type: st.UPDATE, tree: tree
			return

	getByIds: (ids) ->
		(dispatch) ->
			_filterBy dispatch, {ids}
			.then ({data}) ->
				dispatch type: t.GET_SUCCESS, statements: data
			return

module.exports = actions()
