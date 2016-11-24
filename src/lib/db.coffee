pg = require 'easy-pg'
config = require('cson-config').load "#{__dirname}/../../config.cson"

db = ->
	client = pg config.db
	client.on 'ready', -> console.info 'db connected'
	client.on 'end', -> console.info 'db disconnected'
	client.on 'error', (error) -> console.info 'db error', error
	client

module.exports = db()
