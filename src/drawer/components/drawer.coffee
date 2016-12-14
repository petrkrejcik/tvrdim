React = require 'react'
{connect} = require 'react-redux'
loginStatus = React.createFactory require '../../user/components/loginStatus'

appState = (state) ->
	user: state.user
	drawer: state.layout.drawer

drawer = React.createClass

	displayName: 'Drawer'


	getDefaultProps: ->
		user: {}

	render: ->
		cssClasses = ['']
		cssClasses.push 'is-visible' if @props.drawer.isOpened
		if @props.user.id
			user = React.DOM.div className: 'drawer-username', @props.user.displayName
		else
			user = loginStatus {key: 'loginStatus'}

		nav = [
			'Home'
		].map (n, i) ->
			React.DOM.a
				key: "nav-#{i}"
				className: 'nav-item'
			, n

		React.DOM.div
			key: 'drawer'
			className: 'drawer'
		, [
			React.DOM.header key: 'drawer-header', className: 'drawer-header', user
			React.DOM.nav key: 'drawer-nav', className: 'drawer-nav', nav
		]

module.exports = connect(appState) drawer
