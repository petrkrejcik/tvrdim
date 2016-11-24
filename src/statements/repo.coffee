db = require '../lib/db'

repo = ->

	convert = (items) ->
		result = []
		for item in items
			result.push item
		result

	add: (data, done) ->
		doc =
			text: data.text
			createdTime: (new Date).getTime()
		doc.parentId = data.parentId if data.parentId
		doc.weight = data.weight if data.weight
		doc.childrenPos = []
		doc.childrenNeg = []
		db.statement.insert doc, (err, result) ->
			id = result.insertedIds[0]
			if parentId = ObjectID doc.parentId
				children = if data.isPos then 'childrenPos' else 'childrenNeg'
				db.statement.update {_id: parentId}, {$push: "#{children}": $each: [id], $position: 0}, (err, updateResult) ->
					done err, id
			else
				done err, id

		return

	getAll: (done) ->
		db.query 'SELECT * FROM statement', (err, res) ->
			return if err
			done err, convert res.rows
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
