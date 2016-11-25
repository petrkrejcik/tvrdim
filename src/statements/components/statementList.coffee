React = require 'react'
{connect} = require 'react-redux'
statement = React.createFactory require './statement'

appState = (state) ->
	statements: state.statements
	sortRoot: state.statementsTree.root
	tree: state.statementsTree
	statementsPosOpened: state.layout.statements.opened.pos
	statementsNegOpened: state.layout.statements.opened.neg


list = React.createClass

	displayName: 'StatementList'

	render: ->
		cssClasses = ['statementList']
		cssClasses.push @props.nestedType if @props.nestedType

		statements = []
		if @props['sortChildren'].length
			ids = @props['sortChildren']
		else
			ids = @props.tree.root

		for id in ids
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
		tree: {}
		sortChildren: []


module.exports = connect(appState) list
