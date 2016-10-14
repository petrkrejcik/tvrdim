React = require 'react'
statementList = React.createFactory require '../../statements/components/statementList'
{connect} = require 'react-redux'


appState = (state) ->
	statements: state.statement



app = React.createClass

	render: ->
		React.DOM.div
			'className': 'app'
		, statementList {}


module.exports = connect(appState) app
