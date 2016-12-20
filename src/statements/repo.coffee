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
		{userId} = query
		params = []
		user = ''
		if userId
			params.push userId
			i = params.length
			user = "AND s.user_id = $#{i}"
		new Promise (resolve, reject) ->
			db.queryAll "
				SELECT s.id, s.text
				FROM statement s
				JOIN statement_closure sc ON (s.id = sc.descendant)
				WHERE
					sc.ancestor = 1 AND
					sc.descendant <> 1 AND
					sc.depth = 1
					#{user};
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
					#{direct};
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
		new Promise (resolve, reject) ->
			dbEntities = {}
			_getRoot({userId})
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
		errors = null
		if filter.parentIds and !Array.isArray filter.parentIds
			errors ?= []
			errors.push
				'error': "Filter error. ParentIds has to be an array: '#{filter.parentIds}'"
		if filter.userId and !Number.isInteger filter.userId
			errors ?= []
			errors.push
				'error': "Filter error. UserId has to be an integer: '#{filter.userId}'"
		if filter.loggedUserId and !Number.isInteger filter.loggedUserId
			errors ?= []
			errors.push
				'error': "Filter error. LoggedUserId has to be an integer: '#{filter.loggedUserId}'"
		errors


	add: (data, done) ->
		addNew = (data) ->
			new Promise (resolve, reject) ->
				row =
					text: data.text
					user_id: data.userId
					created_time: 'NOW'
				db.insert 'statement', row, (err, res) ->
					return reject err if err
					{id} = res[0]
					resolve id
				return

		addSelfToClosure = (id) ->
			new Promise (resolve, reject) ->
				self =
					ancestor: id
					descendant: id
					depth: 0
				db.insert 'statement_closure', self, (err, res) ->
					return reject err if err
					resolve id
				return

		addSelfToParent = (id) ->
			new Promise (resolve, reject) ->
				{parentId, agree} = data
				agree = null unless agree?
				parentId = 1 unless parentId # __ROOT__
				db.query '
					INSERT INTO statement_closure (ancestor, descendant, depth, agree)
						SELECT ancestor, $1, depth + 1, CASE WHEN depth + 1 = 1 THEN CAST($3 AS BOOLEAN) END
						FROM statement_closure
						WHERE
							descendant = $2
				', [id, parentId, agree], (err, res) ->
					return reject err if err
					resolve id
				return

		new Promise (resolve, reject) ->
			db.begin (err, res) ->
				return reject err if err
				addNew data
				.then addSelfToClosure
				.then addSelfToParent
				.then (id) ->
					db.commit (err, res) ->
						return reject err if err
						resolve id
				.catch (error) ->
					db.rollback()
					reject error
				return

	getAll: (query) ->
		_select query

	filterBy: (filter = {}) ->
		new Promise (resolve, reject) ->
			return reject errors if errors = _validate filter
			if filter.parentIds
				_getChildrenEntities filter.parentIds
				.then (children) ->
					tree = _makeTree children.entities
					entities = children.entities
					resolve {entities, tree}
				.catch reject
			else
				resolve _select filter
			return

	###
	# Removing id and all his children from DB
	###
	remove: (id, parentId, loggedUserId) ->
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
		_deleteFromClosure = (parentId, childrenIds) ->
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
			parentId = 1 unless parentId
			_getChildren()
			.then (ids) ->
				db.begin (err, res) ->
					_deleteFromClosure parentId, ids
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
