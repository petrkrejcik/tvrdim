{
	SYNC_REQUEST
	UPDATE_STATEMENT_ID
	SYNC_FAIL
	SAVE_STATE
} = require './actionTypes'

module.exports =

	sync: ->
		{
			type: SAVE_STATE
		}
