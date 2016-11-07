React = require 'react'
statementList = React.createFactory require '../../statements/components/statementList'
newStatement = React.createFactory require '../../statements/components/newStatement'
{connect} = require 'react-redux'


appState = (state) ->
	statements: state.statement



app = React.createClass

	render: ->
		React.DOM.div
			'className': 'app'
		, [
			newStatement key: 'addStatement'
		,
			statementList key: 'statementList'
		]


module.exports = connect(appState) app
