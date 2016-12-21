React = require 'react'
{connect} = require 'react-redux'
Statement = React.createFactory require './statement'

appState = (state) ->
	tree: state.statementsTree

list = React.createClass

	displayName: 'StatementList'

	getDefaultProps: ->
		statements: []
		cssClasses: []

	render: ->
		cssClasses = @props.cssClasses.concat ['statement-list']
		children = @props.statements.map (statement) =>
			Statement Object.assign {}, statement,
				key: "statement-#{statement.id}"
				childrenCount: @props.tree[statement.id]?.length ? 0

		return @_empty() unless children.length

		React.DOM.div
			key: 'statement-list'
			className: cssClasses.join ' '
		, children

	_empty: ->
		React.DOM.div
			key: 'statement-list-empty'
			className: 'warning'
		, React.DOM.p key: 'warning-text', 'You don\'t have any statements. Add some!'


module.exports = connect(appState) list
