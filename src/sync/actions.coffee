{
	SYNC_REQUEST
	SYNC_STATEMENT_SUCCESS
	SYNC_STATEMENT_FAIL
	SAVE_STATE
} = require './actionTypes'

module.exports =

	sync: ->
		{
			type: SAVE_STATE
		}
