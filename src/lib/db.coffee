pg = require 'easy-pg'
config = require '../../config'

db = ->
	client = pg config.db
	client.on 'ready', -> return
	client.on 'end', -> console.info 'db disconnected'
	client.on 'error', (error) ->
		console.info 'db error', error
		process.exit 1
	client

module.exports = db()
