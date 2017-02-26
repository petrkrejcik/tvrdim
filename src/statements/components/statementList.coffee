React = require 'react'
{connect} = require 'react-redux'
Statement = React.createFactory require './statement'


module.exports = React.createClass

	displayName: 'StatementList'

	getDefaultProps: ->
		statements: []
		cssClasses: []

	render: ->
		cssClasses = @props.cssClasses.concat ['statement-list']
		children = @props.statements.map (statement) -> Statement statement

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
