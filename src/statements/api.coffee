express = require 'express'
router = express.Router()

router.post '/statement/add', (req, res) ->
	res.setHeader 'Content-Type', 'application/json'
	res.json 'id': Math.random()
	return

module.exports = router
