defaulState = require '../statementMock'

module.exports =

	statement: (state = defaulState, action) ->
		switch action.type
			when 'INCREMENT'
				state++
			when 'DECREMENT'
				state--
			else
				state

