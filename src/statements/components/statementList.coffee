React = require 'react'
{connect} = require 'react-redux'
statement = React.createFactory require './statement'

appState = (state) ->
	statements: state.statements
	sortRoot: state.statementsTree.root
	tree: state.statementsTree
	opened: state.layout.statements.opened
	statementsPosOpened: state.layout.statements.opened.pos
	statementsNegOpened: state.layout.statements.opened.neg


list = React.createClass

	displayName: 'StatementList'


	getDefaultProps: ->
		statements: []
		nestedType: ''
		sortRoot: []
		tree: {}
		sortChildren: []
		opened: []


	render: ->
		cssClasses = ['statementList']
		cssClasses.push @props.nestedType if @props.nestedType

		statements = []
		for id in @props.tree.root
			statements.push statement Object.assign @props.statements[id], key: id
			@_renderChildren id, statements

		React.DOM.div
			'className': cssClasses.join ' '
		, statements

	_renderChildren: (parentId, list, depth = 1) ->
		return unless parentId in @props.opened.pos
		for id in @props.tree[parentId]
			props =
				key: "statement-#{id}"
				depth: depth
			list.push statement Object.assign {}, @props.statements[id], props
			@_renderChildren id, list, depth + 1
		return


module.exports = connect(appState) list
