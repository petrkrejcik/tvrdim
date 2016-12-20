t = require './actionTypes'
l = require '../layout/actionTypes'
st = require '../statementsTree/actionTypes'
fetch = require 'isomorphic-fetch'

actions = ->

	# _filterBy = (dispatch, filter) ->
	# 	dispatch type: t.GET_REQUEST # to by mel vypalit nekdo jinej, na miste, odkud se to vola
	# 	params = encodeURIComponent JSON.stringify filter
	# 	fetch "/api/0/statements?q=#{params}"
	# 	.then (response) -> response.json response

	addStatement: (parentId, text, agree, userId) ->

		# mel bych ukladal lokalne vzdy
		# ulozit lokalne
		# ulozit vygenerovany idcko normalne do state
		# odeslat request na ulozeni
		# prepsat ve state provizorni idcko tim novym
		# je tam na picu, ze uz bude ve state ulozeny na vice mistech

		_storeLocally = ->
			new Promise (resolve, reject) ->
				id = Math.random().toString(36).substring(7);
				return resolve {id}

		_storeOnServer = (statement) ->
			fetch '/api/0/statements',
				method: 'post'
				credentials: 'same-origin'
				headers:
					'Accept': 'application/json',
					'Content-Type': 'application/json'
				body: JSON.stringify statement
			.then (response) -> response.json response

		(dispatch) ->
			statement = {parentId, text, agree}
			dispatch type: l.STATEMENT_ADD_REQUEST, {parentId}
			storeFn = if userId
				_storeOnServer.bind @, statement
			else
				_storeLocally.bind @
			storeFn()
			.then ({error, id}) ->
				return dispatch {type: t.ADD_FAILURE, error} if error
				statement = {id, text, agree}
				statement.ancestor = parentId if parentId
				statement.isMine = yes
				dispatch type: t.ADD, statement: "#{id}": statement
				dispatch type: st.ADD, statement: {parentId, id}
				dispatch type: t.COUNT_SCORE, parentId: parentId, id: id
				dispatch type: l.STATEMENT_ADD_SUCCESS, {statement}
				dispatch type: l.STATEMENT_OPEN, statement: {id: parentId, agree}
			return

	getAll: ->
		(dispatch) ->
			dispatch type: t.GET_REQUEST # to by mel vypalit nekdo jinej, na miste, odkud se to vola
			fetch '/api/0/statements'
			.then (response) -> response.json response
			.then ({entities, tree}) ->
				Object.keys(entities).map (id) -> tree[id] = [] unless tree[id]
				dispatch type: t.GET_SUCCESS, statements: entities
				dispatch type: st.UPDATE, tree: tree
			return

	# getDirectChildren: (parentIds) ->
	# 	# not used
	# 	(dispatch) ->
	# 		_filterBy dispatch, {parentIds}
	# 		.then ({entities, tree}) ->
	# 			Object.keys(entities).map (id) -> tree[id] = [] unless tree[id]
	# 			dispatch type: t.GET_SUCCESS, statements: entities
	# 			dispatch type: st.UPDATE, tree: tree
	# 		return

	getByIds: (ids) ->
		(dispatch) ->
			_filterBy dispatch, {ids}
			.then ({data}) ->
				dispatch type: t.GET_SUCCESS, statements: data
			return

	remove: (id, parentId) ->
		parent = ''
		parent = "/#{parentId}" if parentId
		(dispatch) ->
			fetch "/api/0/statements/#{id}#{parent}",
				method: 'delete'
				credentials: 'same-origin'
			.then (response) -> response.json response
			.then (response) ->
				console.info 'removed?', response
				# return dispatch {type: t.GET_FAILURE, error} if error
				# Object.keys(entities).map (id) -> tree[id] = [] unless tree[id]
				# dispatch type: t.GET_SUCCESS, statements: entities
				# dispatch type: st.UPDATE, tree: tree
				# return
			return

	getMine: ->
		(dispatch) ->
			dispatch type: t.GET_REQUEST # to by mel vypalit nekdo jinej, na miste, odkud se to vola
			fetch '/api/0/statements/mine', credentials: 'same-origin'
			.then (response) -> response.json response
			.then ({error, entities, tree}) ->
				return dispatch {type: t.GET_FAILURE, error} if error
				Object.keys(entities).map (id) -> tree[id] = [] unless tree[id]
				dispatch type: t.GET_SUCCESS, statements: entities
				dispatch type: st.UPDATE, tree: tree
				return
			return

module.exports = actions()
