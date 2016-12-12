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
			'className': cssClasses.join ' '
		, children

	_renderChildren: (children, cssClass) ->
		React.DOM.div
			'className': "statement-list #{cssClass}"
		, children


module.exports = connect(appState) list
