l = require './actionTypes'

module.exports =

	toggleVisibility: (id, isApproving, open) ->
		type = if open then l.STATEMENT_OPEN else l.STATEMENT_CLOSE
		statement = {id, isApproving}
		{type, statement}
