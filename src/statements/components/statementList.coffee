React = require 'react'
{connect} = require 'react-redux'
statement = React.createFactory require './statement'

appState = (state) ->
	statements: state.statements


list = React.createClass

	displayName: 'StatementList'


	getDefaultProps: ->
		statementIds: []
		cssClasses: []

	render: ->
		cssClasses = @props.cssClasses.concat ['statement-list']
		children = @props.statementIds.map (id) =>
			statement Object.assign {}, @props.statements[id], key: "statement-#{id}"

		React.DOM.div
			key: 'statement-list'
			className: cssClasses.join ' '
		, children


module.exports = connect(appState) list
