express = require 'express'
router = express.Router()
bodyParser = require 'body-parser'
jsonParser = bodyParser.json()
repo = require './repo'

###
entities:
	1:
		id: 1
		text: 'Foo bar'
	2...
tree:
	root: [1, 5] // without parent
	2:
		pos: [2, 3]
		neg: [4]
	6...
###
router.get '/statement/get', (req, res) ->
	res.setHeader 'Content-Type', 'application/json'
	repo.getAll()
	.then (result) ->
		res.json result
	return

router.post '/statement/filter', jsonParser, (req, res) ->
	filterData = req.body
	repo.filterBy filterData
	.then (result) ->
		res.setHeader 'Content-Type', 'application/json'
		res.json result
	return

router.post '/statement/add', jsonParser, (req, res) ->
	repo.add req.body
	.then (id) ->
		res.setHeader 'Content-Type', 'application/json'
		res.json {id}
	.catch -> console.info 'adding error'
	return

module.exports = router