l = require './actionTypes'

module.exports =

	toggleVisibility: (id, agree, open) ->
		type = if open then l.STATEMENT_OPEN else l.STATEMENT_CLOSE
		statement = {id, agree}
		{type, statement}
