React = require 'react'
{connect} = require 'react-redux'

appState = (state) ->
	{}

loginStatus = React.createClass

	displayName: 'Login Status'


	getDefaultProps: ->
		{}

	render: ->
		React.DOM.a
			href: '/login/facebook'
		, 'Login via Facebook'

module.exports = connect(appState) loginStatus
