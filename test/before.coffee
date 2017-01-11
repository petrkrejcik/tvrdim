db = require '../src/lib/db'
fs = require 'fs'
path = require 'path'

before = ->
	return new Promise (resolve, reject) ->
		query = fs.readFileSync(path.resolve 'dbInit.sql').toString()
		db.query query, (err, res) ->
			return reject err if err
			resolve()
		return

module.exports = before
