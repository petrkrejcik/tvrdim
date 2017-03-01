l = require './actionTypes'

module.exports =

	openMenu: (statementId) ->
		{
			type: l.STATEMENT_MENU_OPEN
			data: {statementId}
		}

	closeMenu: ->
		{
			type: l.STATEMENT_MENU_CLOSE
		}

	openDrawer: ->
		{
			type: l.DRAWER_OPEN
		}

	closeDrawer: ->
		{
			type: l.DRAWER_CLOSE
		}
