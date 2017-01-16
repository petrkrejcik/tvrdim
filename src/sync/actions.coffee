{
	SYNC_STATEMENT_REQUEST
	SYNC_STATEMENT_SUCCESS
	SYNC_STATEMENT_FAIL
	SYNC_STATE_LOCAL
} = require './actionTypes'

module.exports =

	sync: ->
		{
			type: SYNC_STATE_LOCAL
		}
