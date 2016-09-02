React = require 'react'
{connect} = require 'react-redux'
statement = require './statement'

appState = (state) ->
	statements: state.statements


list = React.createFactory React.createClass

	render: ->
		React.DOM.div
			'className': 'statementList'
		, @props.statements.map (statementProps) -> statement statementProps

	getDefaultProps: ->
		statements: []


module.exports = connect(appState) list
