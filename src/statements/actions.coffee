t = require './actionTypes'
fetch = require 'isomorphic-fetch'

module.exports = ->

	_addStatementClick = (parentId) ->
		console.info 'click'
		type: t.ADD_CLICK
		parentId: parentId

	_addStatementSuccess = ({id}) ->
		type: t.ADD_SUCCESS
		id: id

	addStatement: (parentId, text, isPos) ->
		(dispatch) ->
			dispatch _addStatementClick parentId
			fetch '/api/0/statement/add',
				method: 'post'
				headers:
					'Accept': 'application/json',
					'Content-Type': 'application/json'
				body: JSON.stringify {parentId, text, isPos}
			.then (response) -> response.json response
			.then (data) -> dispatch _addStatementSuccess data
			return
