React = require 'react'
{connect} = require 'react-redux'
loginStatus = React.createFactory require '../../user/components/loginStatus'

appState = (state) ->
	user: state.user

drawer = React.createClass

	displayName: 'Drawer'


	getDefaultProps: ->
		user: {}

	render: ->
		if @props.user.id
			user = React.DOM.div className: 'drawer-username', @props.user.displayName
		else
			user = loginStatus {key: 'loginStatus'}

		React.DOM.div
			key: 'drawer'
			className: 'drawer'
		, [
			React.DOM.header
				key: 'drawer-header'
				className: 'drawer-header'
			, user
			React.DOM.nav
				key: 'drawer-nav'
				className: 'drawer-nav'
		]

module.exports = connect(appState) drawer
