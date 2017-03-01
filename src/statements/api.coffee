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
	2: [2, 3]
	6: ...
###
router.get '/statements/mine', (req, res) ->
	res.setHeader 'Content-Type', 'application/json'
	unless user = req.user
		return res.json error: 'Not logged'
	repo.select userId: user.id, loggedUserId: user.id
	.then (result) ->
		res.json result
	.catch (error) ->
		console.info 'Get mine statements error', error
		res.status(500).send error: 'Get mine statements error'
	return

router.get '/statements?', (req, res) ->
	res.setHeader 'Content-Type', 'application/json'
	try
		filter = JSON.parse req.query.q
	catch
		filter = {}
	if user = req.user
		filter.loggedUserId = user.id
	repo.select filter
	.then (result) ->
		res.json result
	.catch (error) ->
		console.info 'Get statements error', error
		res.status(500).send error: 'Get statements error'
	return

# Insert
router.post '/statements', jsonParser, (req, res) ->
	unless user = req.user
		return res.status(403).send error: 'Not logged'
	data = {}
	Object.assign data, req.body
	data.userId = req.user.id
	repo.add data
	.then (id) ->
		res.setHeader 'Content-Type', 'application/json'
		res.json {id}
	.catch (error) ->
		console.info 'Add statement error', error
		res.status(500).send error: 'Add statement error'
	return

# Update
router.put '/statements?', jsonParser, (req, res) ->
	unless user = req.user
		return res.status(403).send error: 'Not logged'
	res.setHeader 'Content-Type', 'application/json'
	data = {}
	Object.assign data, req.body
	data.loggedUserId = req.user.id
	repo.update data
	.then (updated) ->
		return res.status(404).send error: 'Statement not found' unless updated
		res.json updated
	.catch (err) ->
		console.info 'update error', err
		return res.status(500).send error: 'Error when updating.'
	return

router.delete '/statements/:id/:ancestor?', (req, res) ->
	unless user = req.user
		return res.status(403).send error: 'Not logged'
	res.setHeader 'Content-Type', 'application/json'
	id = req.params.id
	ancestor = req.params.ancestor
	unless id
		return res.status(404).send error: 'No ID provided'
	repo.remove id, ancestor, user.id
	.then (ids) ->
		res.json {ids}
	.catch (err) ->
		console.info 'remove error', err
		return res.status(500).send error: 'Error when deleting. Maybe already deleted?'
	return

module.exports = router
