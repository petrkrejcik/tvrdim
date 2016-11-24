pg = require 'easy-pg'

db = ->
	client = pg 'pg://pedro:pedro@localhost/tvrdim_dev'
	client.on 'ready', -> console.info 'db connected'
	client.on 'end', -> console.info 'db disconnected'
	client.on 'error', (error) -> console.info 'db error', error
	client

module.exports = db()
