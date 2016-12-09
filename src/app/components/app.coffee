React = require 'react'
statementList = React.createFactory require '../../statements/components/statementList'
newStatement = React.createFactory require '../../statements/components/newStatement'
loginStatus = React.createFactory require '../../user/components/loginStatus'
{connect} = require 'react-redux'


appState = (state) ->
	statements: state.statement



app = React.createClass

	getDefaultProps: ->
		user: null

	render: ->
		React.DOM.div
			'className': 'app'
		, [
			loginStatus {key: 'loginStatus'}
			newStatement key: 'addStatement'
		,
			statementList key: 'statementList'
		]


module.exports = connect(appState) app
