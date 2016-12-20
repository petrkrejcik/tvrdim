React = require 'react'
{connect} = require 'react-redux'
Statement = React.createFactory require './statement'

appState = (state) ->
	{}

list = React.createClass

	displayName: 'StatementList'

	getDefaultProps: ->
		statements: []
		cssClasses: []

	render: ->
		cssClasses = @props.cssClasses.concat ['statement-list']
		children = @props.statements.map (statement) =>
			Statement Object.assign {}, statement, key: "statement-#{statement.id}"

		React.DOM.div
			key: 'statement-list'
			className: cssClasses.join ' '
		, children


module.exports = connect(appState) list
