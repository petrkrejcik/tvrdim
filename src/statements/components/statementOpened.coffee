React = require 'react'
{connect} = require 'react-redux'
statement = React.createFactory require './statement'
statementList = React.createFactory require './statementList'
newStatement = React.createFactory require './newStatement'

appState = (state) ->
	statements: state.statements
	tree: state.statementsTree
	opened: state.layout.statements.opened


list = React.createClass

	displayName: 'StatementOpened'


	getDefaultProps: ->
		statements: []
		tree: {}
		opened: null

	render: ->
		cssClasses = ['statement-opened']
		parent = @props.statements[@props.opened]
		childrenIds = @props.tree[parent.id] ? []
		agrees = childrenIds.filter (id) => @props.statements[id].agree
		disagrees = childrenIds.filter (id) => !@props.statements[id].agree

		children = React.DOM.div
			'className': 'children'
		, [
			@_renderChildren disagrees, parent.id, no
			@_renderChildren agrees, parent.id, yes
		]

		React.DOM.div
			'className': cssClasses.join ' '
		, [
			statement Object.assign {}, parent, key: "statement-#{parent.id} opened"
			children
		]

	_renderChildren: (children, parentId, agree) ->
		cssClass = if agree then 'agree' else 'disagree'
		emptyStatement = newStatement
			key: 'empty-statement'
			agree: agree
			parentId: parentId

		React.DOM.div
			'className': "children-#{cssClass}"
		, [
			emptyStatement
			statementList
				statementIds: children
				cssClasses: [cssClass]
			, children
		]


module.exports = connect(appState) list
