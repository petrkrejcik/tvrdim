l = require './actionTypes'
{ANIMATION_HIDE_DURATION} = require '../util/consts'

actions = ->

	_openStatementInit = (statement, top) ->
		{
			type: l.STATEMENT_OPEN_INIT
			statement
			top
		}

	_openStatementStart = (dispatch) ->
		new Promise (resolve, reject) ->
			action = {
				type: l.STATEMENT_OPEN_START
			}
			setTimeout ->
				dispatch action
				resolve()
			, 1
			return

	_openStatementRootStart = (dispatch) ->
		new Promise (resolve, reject) ->
			action = {
				type: l.STATEMENT_OPEN_ROOT_START
			}
			setTimeout ->
				dispatch action
				resolve()
			, 1
			return

	_openStatementEnd = (dispatch) ->
		new Promise (resolve, reject) ->
			action = {
				type: l.STATEMENT_OPEN_END
			}
			setTimeout ->
				dispatch action
				resolve()
			, ANIMATION_HIDE_DURATION
			return

	_openStatementRootEnd = (dispatch) ->
		new Promise (resolve, reject) ->
			action = {
				type: l.STATEMENT_OPEN_ROOT_END
			}
			setTimeout ->
				dispatch action
				resolve()
			, ANIMATION_HIDE_DURATION
			return


	toggleVisibility: (id, open) ->
		type = if open then l.STATEMENT_OPEN else l.STATEMENT_CLOSE
		statement = {id}
		{type, statement}

	open: (statement, top) ->
		(dispatch) ->
			dispatch _openStatementInit statement, top
			_openStatementStart dispatch
			.then -> _openStatementEnd dispatch
			return

	storeTopOffset: (offset) ->
		{
			type: l.STATEMENT_STORE_FIRST_TOP_OFFSET
			offset
		}

	openRoot: ->
		(dispatch) ->
			dispatch type: l.STATEMENT_OPEN_ROOT_INIT
			_openStatementRootStart dispatch
			.then -> _openStatementRootEnd dispatch
			return

	openParent: (statement) ->
		(dispatch) ->
			dispatch _openStatementInit statement, top
			_openStatementStart dispatch
			.then -> _openStatementEnd dispatch
			return

	openDrawer: ->
		{
			type: l.DRAWER_OPEN
		}


module.exports = actions()