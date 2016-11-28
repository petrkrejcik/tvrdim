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

	_getRoot = ->
		new Promise (resolve, reject) ->
			db.queryAll '
				SELECT s.id, s.text
				FROM statement s
				JOIN statement_closure sc ON (s.id = sc.descendant)
				WHERE
					sc.ancestor = 1 AND
					sc.descendant <> 1 AND
					sc.depth = 1;
			', (err, res) ->
				return reject err if err
				resolve entities: _getEntities res
			return

	_getChildren = (parentIds, entireTree = no) ->
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
				SELECT ancestor, descendant AS id, is_approving
				FROM statement_closure
				WHERE
					descendant = ANY ($1) AND
					depth = 1
				', [parentIds], (err, res) ->
				return reject err if err
				resolve _getEntities res
			return


	add: (data, done) ->

		addNew = (data) ->
			new Promise (resolve, reject) ->
				row =
					text: data.text
					# createdTime: (new Date).getTime()
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
				{parentId, isApproving} = data
				parentId = 1 unless parentId # __ROOT__
				db.query '
					INSERT INTO statement_closure (ancestor, descendant, depth, is_approving)
						SELECT ancestor, $1, depth + 1, CASE WHEN depth + 1 = 1 THEN CAST($3 AS BOOLEAN) END
						FROM statement_closure
						WHERE
							descendant = $2
				', [id, parentId, isApproving], (err, res) ->
					return reject err if err
					resolve id
				return

		new Promise (resolve, reject) ->
			db.begin (err, res) ->
				return reject err if err
				addNew data
				.then addSelfToClosure
				.then addSelfToParent
				.then (id) -> db.commit (err, res) ->
					return reject err if err
					resolve id
				return

	getAll: ->
		new Promise (resolve, reject) ->
			_getRoot()
			.then (roots) ->
				rootIds = Object.keys roots.entities
				_getChildren rootIds, yes
			.then (children) ->
				childrenIds = Object.keys children.entities
				_getTree childrenIds
			.then (entitiesRelation) ->
				for id, entity of entitiesRelation
					if entity.is_approving is null
						# is root
						delete entity.ancestor
						delete entity.is_approving
						continue
					entity.isApproving = entity.is_approving
					delete entity.is_approving

				entities = util.countScore entitiesRelation
				tree = _makeTree entitiesRelation
				resolve {entities, tree}
				return
			.catch reject
			return

	filterBy: (filter) ->
		new Promise (resolve, reject) ->
			if filter.parentIds and Array.isArray filter.parentIds
				_getChildren filter.parentIds
				.then (children) ->
					tree = _makeTree children.entities
					entities = children.entities
					resolve {entities, tree}
				.catch reject
			else
				resolve getAll()
			return

module.exports = repo()
