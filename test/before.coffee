db = require '../src/lib/db'
fs = require 'fs'
path = require 'path'
config = require '../config'

before = ->

	dropTable = (tableName) ->
		return new Promise (resolve, reject) ->
			db.query "DROP TABLE IF EXISTS #{tableName};", (err, res) ->
				return reject err if err
				resolve()
			return

	return new Promise (resolve, reject) ->
		dropTable 'statement_closure'
		.then ->
			dropTable 'statement'
		.then ->
			if config.env is 'test'
				return dropTable 'users'
			else
				return Promise.resolve()
		.then ->
			query = fs.readFileSync(path.resolve 'dbInit.sql').toString()
			db.query query, (err, res) ->
				return reject err if err
				resolve()
		.catch (err) ->
			console.info 'Error in before', err
		return

module.exports = before
