emptyState = [
	'key': 'statement1'
	'text': 'statement 1'
,
	'key': 'statement2'
	'text': 'statement 2'
]


module.exports =

	statement: (state = emptyState, action) ->
		switch action.type
			when 'INCREMENT'
				state++
			when 'DECREMENT'
				state--
			else
				state

