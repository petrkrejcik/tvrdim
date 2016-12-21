l = require './actionTypes'

module.exports =

	toggleVisibility: (id, open) ->
		type = if open then l.STATEMENT_OPEN else l.STATEMENT_CLOSE
		statement = {id}
		{type, statement}

	open: (id) ->
		{
			type: l.STATEMENT_OPEN
			id
		}

	openRoot: ->
		{
			type: l.STATEMENT_OPEN_ROOT
		}

	openDrawer: ->
		{
			type: l.DRAWER_OPEN
		}

	closeDrawer: ->
		{
			type: l.DRAWER_CLOSE
		}
