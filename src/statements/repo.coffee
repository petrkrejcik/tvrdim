db = require '../lib/db'

repo = ->

	convert = (items) ->
		result = []
		for item in items
			result.push item
		result

	add: (data, done) ->

		addNew = (data) ->
			new Promise (resolve, reject) ->
				console.info 'addNew...'
				row =
					text: data.text
					# createdTime: (new Date).getTime()
				db.insert 'statement', row, (err, res) ->
					console.info 'err', err if err
					console.info 'res', res
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
					console.info 'res', res
					return reject err if err
					resolve id
				return

		addSelfToParent = (id) ->
			new Promise (resolve, reject) ->
				console.info 'addSelfToParent...'
				resolve id unless parentId = data.parentId
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

		# db.query 'INSERT INTO statement (text) VALUES', (err, res) ->

		# doc =
		# 	text: data.text
		# 	createdTime: (new Date).getTime()
		# doc.parentId = data.parentId if data.parentId
		# doc.weight = data.weight if data.weight
		# doc.childrenPos = []
		# doc.childrenNeg = []
		# db.statement.insert doc, (err, result) ->
		# 	id = result.insertedIds[0]
		# 	if parentId = ObjectID doc.parentId
		# 		children = if data.isPos then 'childrenPos' else 'childrenNeg'
		# 		db.statement.update {_id: parentId}, {$push: "#{children}": $each: [id], $position: 0}, (err, updateResult) ->
		# 			done err, id
		# 	else
		# 		done err, id

	getAll: ->
		new Promise (resolve, reject) ->

			db.query 'SELECT * FROM statement', (err, res) ->
			# db.query 'SELECT * FROM statement s JOIN statement_closure sc ON (s.id = sc.id);', (err, res) ->
				console.info 'queried'
				console.log JSON.stringify(err, null, 4)
				return reject err if err
				resolve convert res.rows
				# done err, convert res.rows
		# db.statement.find().sort(createdTime: -1).toArray (err, result) ->
		# 	done err, convert result
		# 	return
		# return

	filterBy: (filter, done) ->
		db.query 'SELECT * FROM statement', (err, res) ->
			return if err
			done err, convert res.rows
		# db.statement.find(filter).sort(createdTime: -1).toArray (err, result) ->
		# 	done err, convert result
		# 	return
		# return

module.exports = repo()
