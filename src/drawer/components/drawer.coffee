React = require 'react'
{connect} = require 'react-redux'
loginStatus = React.createFactory require '../../user/components/loginStatus'
{logout} = require '../../user/actions'

appState = (state) ->
	user: state.user


dispatchToProps = (dispatch) ->
	handleLogoutClick: ->
		dispatch logout()


drawer = React.createClass

	displayName: 'Drawer'


	getDefaultProps: ->
		user: {}

	render: ->
		items = []

		if @props.user.id
			user = React.DOM.div className: 'drawer-username', @props.user.displayName
			items.push @_createItem 'Logout', @props.handleLogoutClick
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
			, items
		]

	_createItem: (text, handler) ->
		React.DOM.a
			key: 'nav-item'
			className: 'nav-item'
			onClick: handler
		, [
			React.DOM.i
				key: 'icon-logout'
				className: 'material-icons', 'more_vert'
		, text
		]


module.exports = connect(appState, dispatchToProps) drawer
