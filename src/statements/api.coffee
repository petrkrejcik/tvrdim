express = require 'express'
router = express.Router()
bodyParser = require 'body-parser'
jsonParser = bodyParser.json()
repo = require './repo'

router.get '/statement/get', (req, res) ->
	res.setHeader 'Content-Type', 'application/json'
	repo.getAll (err, items) ->
		res.json data: items
	return

router.post '/statement/filter', jsonParser, (req, res) ->
	filterData = req.body
	filter = {}
	if filterData.withoutChildren
		filter['parentId'] = $exists: no
	if filterData.ids
		filter['_id'] = $in: filterData.ids
	repo.filterBy filter, (err, result) ->
		res.json data: result
	return

router.post '/statement/add', jsonParser, (req, res) ->
	repo.add req.body, (err, id) ->
		res.setHeader 'Content-Type', 'application/json'
		res.json {id}
		return
	return

module.exports = router
