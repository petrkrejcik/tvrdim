React = require 'react'
{connect} = require 'react-redux'
statement = React.createFactory require './statement'

appState = (state) ->
	statements = state.statements
	# statements = state.statements.map (st) ->
	# 	st.isPosOpened = st.id in state.layout.statements.openedPos
	# 	st.isNegOpened = st.id in state.layout.statements.openedNeg
	# 	st
	{statements}


list = React.createClass

	displayName: 'StatementList'

	render: ->
		cssClasses = ['statementList']
		cssClasses.push @props.nestedType if @props.nestedType

		statements = []
		for id, statementProps of @props.statements
			props =
				listFactory: React.createFactory list
				key: id
			props[key] = value for key, value of statementProps
			statements.push statement props

		React.DOM.div
			'className': cssClasses.join ' '
		, statements

	getDefaultProps: ->
		statements: []
		nestedType: ''


module.exports = connect(appState) list
