React = require 'react'
statementList = require './statement/statementList'
{connect} = require 'react-redux'


appState = (state) ->
	statements: state.statements



app = React.createFactory React.createClass

	render: ->
		React.DOM.div
			'className': 'app'
		, React.createElement statementList


module.exports = connect(appState) app
