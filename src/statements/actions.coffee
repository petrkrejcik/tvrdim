t = require './actionTypes'
fetch = require 'isomorphic-fetch'

module.exports = ->

	_addStatementClick = (parentId) ->
		console.info 'click'
		type: t.ADD_CLICK
		parentId: parentId

	_addStatementSuccess = (response) ->
		console.info 'success', response
		type: t.ADD_SUCCESS
		id: response

	addStatement: (parentId, text, isPos) ->
		console.info 'addStatement'
		(dispatch) ->
			dispatch _addStatementClick parentId
			fetch '/api/0/statement/add',
				method: 'post'
				headers:
					'Accept': 'application/json',
					'Content-Type': 'application/json'
				body: JSON.stringify {parentId, text, isPos}
			.then (response) ->
				dispatch _addStatementSuccess response
				return

