React = require 'react'
{connect} = require 'react-redux'
statement = React.createFactory require './statement'

appState = (state) ->
	statements: state.statements
	sortRoot: state.statementsTree.root
	tree: state.statementsTree
	opened: state.layout.statements.opened


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
			@_renderChildren id, statements, 1, no
			@_renderChildren id, statements, 1, yes

		React.DOM.div
			'className': cssClasses.join ' '
		, statements

	_renderChildren: (parentId, list, depth, isApproving) ->
		key = if isApproving then 'approving' else 'rejecting'
		return unless parentId in @props.opened[key]
		for id in @props.tree[parentId]
			continue unless @props.statements[id].isApproving is isApproving
			props =
				key: "statement-#{id}"
				depth: depth
			list.push statement Object.assign {}, @props.statements[id], props
			@_renderChildren id, list, depth + 1, no
			@_renderChildren id, list, depth + 1, yes
		return


module.exports = connect(appState) list
