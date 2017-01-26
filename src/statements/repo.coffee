db = require '../lib/db'
util = require './util'

repo = ->

	_getEntities = (items) ->
		entities = {}
		for item in items
			entities[item.id] = item
		entities

	_makeTree = (entities) ->
		tree = {}
		for id, child of entities
			if id is child.ancestor or !child.ancestor?
				tree['root'] ?= []
				tree['root'].push id
			else
				tree[child.ancestor] ?= []
				tree[child.ancestor].push id
		tree

	_getRoot = (query = {}) ->
		{userId, isLogged} = query
		params = []
		user = ''
		onlyPublic = ''
		if userId
			params.push userId
			i = params.length
			user = "AND s.user_id = $#{i}"
		unless isLogged
			onlyPublic = "AND s.is_private IS NULL"
		new Promise (resolve, reject) ->
			db.queryAll "
				SELECT s.id, s.text
				FROM statement s
				JOIN statement_closure sc ON (s.id = sc.descendant)
				WHERE
					sc.ancestor = 1 AND
					sc.descendant <> 1 AND
					sc.depth = 1
					#{user}
					#{onlyPublic}
				ORDER BY s.created_time DESC;
			", params, (err, res) ->
				return reject err if err
				resolve entities: _getEntities res
			return

	_getChildrenEntities = (parentIds, entireTree = no) ->
		new Promise (resolve, reject) ->
			direct = if entireTree then '' else 'AND sc.depth = 1'
			db.queryAll "
				SELECT s.*, sc.ancestor
				FROM statement s
				JOIN statement_closure sc ON (s.id = sc.descendant)
				WHERE
					sc.ancestor = ANY ($1)
					#{direct}
				ORDER BY s.created_time DESC;
			", [parentIds], (err, res) ->
				return reject err if err
				resolve entities: _getEntities res
			return

	_getTree = (parentIds) ->
		new Promise (resolve, reject) ->
			db.queryAll '
				SELECT CAST(ancestor AS TEXT), CAST(descendant AS TEXT) AS id, agree
				FROM statement_closure
				WHERE
					descendant = ANY ($1) AND
					depth = 1
				', [parentIds], (err, res) ->
				return reject err if err
				resolve _getEntities res
			return

	_select = (query = {}) ->
		{userId, loggedUserId} = query
		isLogged = loggedUserId and (userId is loggedUserId)
		new Promise (resolve, reject) ->
			dbEntities = {} # contains all statement's atributes
			_getRoot({userId, isLogged})
			.then (roots) ->
				rootIds = Object.keys roots.entities
				_getChildrenEntities rootIds, yes
			.then (children) ->
				dbEntities = children.entities
				childrenIds = Object.keys children.entities
				_getTree childrenIds
			.then (entitiesRelation) ->
				for id, entity of entitiesRelation
					entity.text = dbEntities[id].text
					entity.createdTime = dbEntities[id].created_time
					entity.isMine = yes if dbEntities[id].user_id is loggedUserId
					entity.isPrivate = yes if dbEntities[id].is_private
					if entity.agree is null
						# is root
						delete entity.ancestor
						continue
				entities = util.countScore entitiesRelation
				tree = _makeTree entitiesRelation
				resolve {entities, tree}
				return
			.catch reject
			return

	_validate = (filter = {}) ->
		if filter.parentIds and !Array.isArray filter.parentIds
			return 'error': "Filter error. ParentIds has to be an array: '#{filter.parentIds}'"
		if filter.userId and !Number.isInteger filter.userId
			return 'error': "Filter error. UserId has to be an integer: '#{filter.userId}'"
		if filter.loggedUserId and !Number.isInteger filter.loggedUserId
			return 'error': "Filter error. LoggedUserId has to be an integer: '#{filter.loggedUserId}'"
		return


	### @todo use insert() ###
	add: (data) ->
		_insert = (data) ->
			new Promise (resolve, reject) ->
				row =
					text: data.text
					user_id: data.userId
					created_time: 'NOW'
					is_private: yes if data.isPrivate
				db.insert 'statement', row, (err, res) ->
					return reject err if err
					{id} = res[0]
					resolve id
				return

		_insertToTree = (id) ->
			new Promise (resolve, reject) ->
				self =
					ancestor: id
					descendant: id
					depth: 0
				db.insert 'statement_closure', self, (err, res) ->
					return reject err if err
					resolve id
				return

		_insertToTreeParent = (id) ->
			new Promise (resolve, reject) ->
				{ancestor, agree} = data
				agree = null unless agree?
				ancestor = 1 unless ancestor # __ROOT__
				db.query '
					INSERT INTO statement_closure (ancestor, descendant, depth, agree)
						SELECT ancestor, $1, depth + 1, CASE WHEN depth + 1 = 1 THEN CAST($3 AS BOOLEAN) END
						FROM statement_closure
						WHERE
							descendant = $2
				', [id, ancestor, agree], (err, res) ->
					return reject err if err
					resolve id
				return

		new Promise (resolve, reject) ->
			db.begin (err, res) ->
				return reject err if err
				_insert data
				.then _insertToTree
				.then _insertToTreeParent
				.then (id) ->
					db.commit (err, res) ->
						return reject err if err
						resolve id.toString()
				.catch (error) ->
					db.rollback()
					reject error
				return

	select: (query = {}) ->
		new Promise (resolve, reject) ->
			if errors = _validate query
				return reject errors
			if query.parentIds
				_getChildrenEntities query.parentIds
				.then (children) ->
					tree = _makeTree children.entities
					entities = children.entities
					resolve {entities, tree}
				.catch reject
			else
				resolve _select query
			return

	###
	# Removing id and all his children from DB
	###
	remove: (id, ancestor, loggedUserId) ->
		_getChildren = ->
			new Promise (resolve, reject) ->
				db.queryAll '
					SELECT descendant
					FROM statement_closure
					WHERE
						ancestor = $1
				', [id], (err, rows) ->
					return reject err if err
					resolve rows.map (row) -> row.descendant
				return
		_deleteFromClosure = (ancestor, childrenIds) ->
			new Promise (resolve, reject) ->
				db.queryAll '
					DELETE
					FROM statement_closure
					WHERE
						ancestor = ANY ($1) OR
						descendant = ANY ($1)
				', [childrenIds], (err, rows) ->
					return reject err if err
					resolve rows.map (row) -> row.descendant
				return
		_deleteFromStatements = (ids) ->
			new Promise (resolve, reject) ->
				db.delete 'statement', 'id = ANY ($1) AND user_id = $2', [ids, loggedUserId], (err, rows) ->
					return reject err if err
					resolve rows.map (row) -> row.id
				return

		new Promise (resolve, reject) ->
			ancestor = 1 unless ancestor
			_getChildren()
			.then (ids) ->
				db.begin (err, res) ->
					_deleteFromClosure ancestor, ids
					.then ->
						_deleteFromStatements [id]
					.then (ids) ->
						if ids.length is 0
							# statement was not mine, so cancel deleting
							db.rollback()
							return reject()
						db.commit()
						resolve ids
					.catch (err) ->
						db.rollback()
						reject err
			.catch (err) -> reject err
			return

module.exports = repo()
