t = require './actionTypes'
l = require '../layout/actionTypes'
st = require '../statementsTree/actionTypes'
fetch = require 'isomorphic-fetch'

actions = ->

	_addStatementClick = (parentId) ->
		type: t.ADD_CLICK
		parentId: parentId

	_addStatementSuccess = (statement) ->
		type: t.ADD_SUCCESS
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
			statement.childrenPos = []
			statement.childrenNeg = []
			dispatch _addStatementClick parentId
			fetch '/api/0/statement/add',
				method: 'post'
				headers:
					'Accept': 'application/json',
					'Content-Type': 'application/json'
				body: JSON.stringify statement
			.then (response) -> response.json response
			.then ({id}) ->
				console.info 'added parent', parentId
				statement.id = id
				dispatch _addStatementSuccess "#{id}": statement
				if parentId
					dispatch
						type: t.ADD_CHILD
						parentId: parentId
						childId: id
						isPos: isPos
				else
					dispatch type: l.STATEMENTS_SORT_ROOT_ADD, id: id
			return

	getRoot: (filter) ->
		(dispatch) ->
			_getRoot dispatch
			.then ({entities, tree}) ->
				dispatch type: st.UPDATE, tree: tree
				dispatch type: t.GET_SUCCESS, statements: entities
			return


	getByIds: (ids) ->
		(dispatch) ->
			_filterBy dispatch, {ids}
			.then ({data}) ->
				dispatch type: t.GET_SUCCESS, statements: data
			return



module.exports = actions()