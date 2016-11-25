db = require '../lib/db'

repo = ->

	_convert = (items) ->
		result = []
		for item in items
			result.push item
		result

	_getEntities = (items) ->
		entities = {}
		for item in items
			entities[item.id] = item
		entities

	_makeTree = (entities) ->
		tree = {}
		for id, child of entities
			continue if(parseInt id) is parseInt child.ancestor
			tree[child.ancestor] ?= []
			tree[child.ancestor].push id
		tree

	_getRoot = ->
		new Promise (resolve, reject) ->
			db.query 'SELECT s.* FROM statement s JOIN statement_closure sc ON (s.id = sc.descendant) WHERE sc.ancestor = 1 AND sc.descendant <> 1 AND sc.depth = 1;', (err, res) ->
				return reject err if err
				resolve entities: _getEntities res.rows

	_getChildren = (parentIds, entireTree = no) ->
		new Promise (resolve, reject) ->
			direct = if entireTree then '' else 'AND sc.depth = 1'
			db.query "SELECT s.*, sc.ancestor FROM statement s JOIN statement_closure sc ON (s.id = sc.descendant) WHERE sc.ancestor = ANY ($1) #{direct};", [parentIds], (err, res) ->
				return reject err if err
				resolve entities: _getEntities res.rows
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
				parentId = data.parentId
				parentId = 1 unless parentId # __ROOT__
				db.query 'INSERT INTO statement_closure (ancestor, descendant, depth) SELECT ancestor, $1, depth + 1 FROM statement_closure WHERE descendant = $2', [id, parentId], (err, res) ->
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
			tree = {}
			entities = {}
			_getRoot()
			.then (roots) ->
				entities = roots.entities
				ids = Object.keys entities
				tree.root = ids
				_getChildren ids
			.then (children) ->
				childrenTree = _makeTree children.entities
				Object.assign entities, children.entities
				Object.assign tree, childrenTree
				resolve {entities, tree}
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
