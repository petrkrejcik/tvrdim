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

router.delete '/statements/:id/parentId/:parentId', (req, res) ->
	res.setHeader 'Content-Type', 'application/json'
	id = req.params.id
	parentId = req.params.parentId
	return res.json error: msg: 'No ID provided' unless id
	repo.remove id, parentId
	.then (ids) ->
		res.json {ids}
	.catch (err) -> console.info 'remove error', err
	return

module.exports = router
