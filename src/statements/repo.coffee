db = require '../lib/db'

repo = ->

	convert = (items) ->
		result = []
		for item in items
			result.push item
		result

	getEntities = (items) ->
		entities = {}
		for item in items
			entities[item.id] = item
		entities

	getRoot = ->
		new Promise (resolve, reject) ->
			db.query 'SELECT s.* FROM statement s JOIN statement_closure sc ON (s.id = sc.descendant) WHERE sc.ancestor = 1 AND sc.descendant <> 1 AND sc.depth = 1;', (err, res) ->
				return reject err if err
				resolve entities: getEntities res.rows

	getChildren = (parentIds) ->
		new Promise (resolve, reject) ->
			db.query 'SELECT s.*, sc.ancestor FROM statement s JOIN statement_closure sc ON (s.id = sc.descendant) WHERE sc.ancestor = ANY ($1);', [parentIds], (err, res) ->
				return reject err if err
				resolve entities: getEntities res.rows
			return

	add: (data, done) ->
		console.info 'adding new...', data

		addNew = (data) ->
			new Promise (resolve, reject) ->
				console.info 'addNew...'
				row =
					text: data.text
					# createdTime: (new Date).getTime()
				db.insert 'statement', row, (err, res) ->
					console.info 'err', err if err
					# console.info 'res', res
					return reject err if err
					{id} = res[0]
					resolve id
				return

		addSelfToClosure = (id) ->
			new Promise (resolve, reject) ->
				console.info 'addSelfToClosure...', id
				self =
					ancestor: id
					descendant: id
					depth: 0
				db.insert 'statement_closure', self, (err, res) ->
					console.info 'err', err if err
					# console.info 'res', res
					return reject err if err
					resolve id
				return

		addSelfToParent = (id) ->
			new Promise (resolve, reject) ->
				console.info 'addSelfToParent...', data.parentId
				parentId = data.parentId
				parentId = 1 unless parentId # __ROOT__
				db.query 'INSERT INTO statement_closure (ancestor, descendant, depth) SELECT ancestor, $1, depth + 1 FROM statement_closure WHERE descendant = $2', [id, parentId], (err, res) ->
					console.info 'err', err if err
					return reject err if err
					resolve id
				return

		new Promise (resolve, reject) ->
			db.begin (err, res) ->
				console.info 'began'
				return reject err if err
				addNew data
				.then addSelfToClosure
				.then addSelfToParent
				.then (id) -> db.commit (err, res) ->
					console.info 'commited', id
					return reject err if err
					resolve id
				return

	getAll: ->
		new Promise (resolve, reject) ->
			tree = {}
			getRoot()
			.then (roots) ->
				ids = Object.keys roots.entities
				tree.root = ids
				getChildren ids
			.then (children) ->
				for id, child of children.entities
					continue if(parseInt id) is parseInt child.ancestor
					tree[child.ancestor] ?= []
					tree[child.ancestor].push id
				resolve
					entities: children.entities
					tree: tree
			.catch reject

	filterBy: (filter, done) ->
		db.query 'SELECT * FROM statement', (err, res) ->
			return if err
			done err, convert res.rows
		# db.statement.find(filter).sort(createdTime: -1).toArray (err, result) ->
		# 	done err, convert result
		# 	return
		# return

module.exports = repo()
