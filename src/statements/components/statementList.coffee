React = require 'react'
{connect} = require 'react-redux'
statement = React.createFactory require './statement'

appState = (state) ->
	statements = state.statements.map (st) ->
		st.isPosOpened = st.id in state.layout.statements.openedPos
		st.isNegOpened = st.id in state.layout.statements.openedNeg
		st
	{statements}


list = React.createClass

	displayName: 'StatementList'

	render: ->
		cssClasses = ['statementList']
		cssClasses.push @props.nestedType if @props.nestedType

		statements = @props.statements.map (statementProps) ->
			statementProps.listFactory = React.createFactory list
			statement statementProps

		React.DOM.div
			'className': cssClasses.join ' '
		, statements

	getDefaultProps: ->
		statements: []
		nestedType: ''


module.exports = connect(appState) list
