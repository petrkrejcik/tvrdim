t = require './actionTypes'
l = require '../layout/actionTypes'
st = require '../statementsTree/actionTypes'
fetch = require 'isomorphic-fetch'

actions = ->

	_getAll = (dispatch) ->
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

	_updateScore = (id, score) ->


	addStatement: (parentId, text, agree) ->
		(dispatch) ->
			statement = {parentId, text, agree}
			dispatch type: l.STATEMENT_ADD_REQUEST, {parentId}
			fetch '/api/0/statement/add',
				method: 'post'
				headers:
					'Accept': 'application/json',
					'Content-Type': 'application/json'
				body: JSON.stringify statement
			.then (response) -> response.json response
			.then ({id}) ->
				statement = {id, text, agree}
				statement.ancestor = parentId if parentId
				parentId = 'root' unless parentId
				dispatch type: t.ADD, statement: "#{id}": statement
				dispatch type: st.ADD, statement: {parentId, id}
				dispatch type: t.COUNT_SCORE, parentId: parentId, id: id
				dispatch type: l.STATEMENT_ADD_SUCCESS, {statement}
				dispatch type: l.STATEMENT_OPEN, statement: {id: parentId, agree}
			return

	getAll: (filter) ->
		(dispatch) ->
			_getAll dispatch
			.then ({entities, tree}) ->
				Object.keys(entities).map (id) -> tree[id] = [] unless tree[id]
				dispatch type: t.GET_SUCCESS, statements: entities
				dispatch type: st.UPDATE, tree: tree
			return

	getDirectChildren: (parentIds) ->
		# not used1
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
