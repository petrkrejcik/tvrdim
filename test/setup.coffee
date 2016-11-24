db = require '../src/lib/db'
fs = require 'fs'
path = require 'path'

before (done) ->
	query = fs.readFileSync(path.resolve 'dbInit.sql').toString()
	db.query query, (err, res) ->
		return done err if err
		done()
	return
