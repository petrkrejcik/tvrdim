React = require 'react'
{connect} = require 'react-redux'
statement = React.createFactory require './statement'

appState = (state) ->
	statements: state.statements
	sortRoot: state.statementsTree.root
	statementsPosOpened: state.layout.statements.opened.pos
	statementsNegOpened: state.layout.statements.opened.neg


list = React.createClass

	displayName: 'StatementList'

	render: ->
		cssClasses = ['statementList']
		cssClasses.push @props.nestedType if @props.nestedType

		statements = []
		if @props['sortChildren'].length
			sort = @props['sortChildren']
		else
			sort = @props['sortRoot']

		for id in sort
			props =
				key: id
				isPosOpened: id in @props.statementsPosOpened
				isNegOpened: id in @props.statementsNegOpened
				listFactory: (props) ->
					React.createFactory(connect(appState) list) props
			props[key] = value for key, value of @props.statements[id]
			statements.push statement props

		React.DOM.div
			'className': cssClasses.join ' '
		, statements

	getDefaultProps: ->
		statements: []
		nestedType: ''
		sortRoot: []
		sortChildren: []


module.exports = connect(appState) list
