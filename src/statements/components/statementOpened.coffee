React = require 'react'
{connect} = require 'react-redux'
statement = React.createFactory require './statement'
statementFilter = React.createFactory require '../containers/statementFilter'
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

		children = React.DOM.div
			key: 'children'
			className: 'children'
		, [
			@_renderChildren parent.id, no
			@_renderChildren parent.id, yes
		]

		React.DOM.div
			key: 'statementOpened'
			className: cssClasses.join ' '
		, [
			statement Object.assign {}, parent, key: "statement-#{parent.id}-opened"
			children
		]

	_renderChildren: (parentId, agree) ->
		cssClass = if agree then 'agree' else 'disagree'
		emptyStatement = newStatement
			key: 'empty-statement'
			agree: agree
			parentId: parentId

		React.DOM.div
			key: "children-#{parentId}-#{cssClass}"
			className: "children-#{cssClass}"
		, [
			# emptyStatement
			statementFilter
				key: "statementFilter-#{parentId}"
				filters: [{parentId}, {agree}]
				cssClasses: [cssClass]
		]


module.exports = connect(appState) list
