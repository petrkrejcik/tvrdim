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
router.get '/statements/mine', (req, res) ->
	res.setHeader 'Content-Type', 'application/json'
	unless user = req.user
		return res.json error: 'Not logged'
	repo.filterBy userId: user.id
	.then (result) ->
		res.json result
	.catch (err) -> console.info 'Get mine statements error', err
	return

router.get '/statements?', (req, res) ->
	res.setHeader 'Content-Type', 'application/json'
	try
		filter = JSON.parse req.query.q
	catch
		filter = {}
	if user = req.user
		filter.userId = user.id
	repo.filterBy filter
	.then (result) ->
		res.json result
	.catch (err) -> console.info 'Get statements error', err
	return

router.post '/statements/add', jsonParser, (req, res) ->
	unless user = req.user
		return res.json error: 'Not logged'
	data = {}
	Object.assign data, req.body
	data.userId = req.user.id
	repo.add data
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
