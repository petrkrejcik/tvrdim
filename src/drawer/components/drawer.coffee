React = require 'react'
{connect} = require 'react-redux'
{logout} = require '../../user/actions'
{closeDrawer} = require '../../layout/actions'

appState = (state) ->
	user: state.user


dispatchToProps = (dispatch) ->
	handleLogoutClick: ->
		dispatch logout()
		dispatch closeDrawer()


drawer = React.createClass

	displayName: 'Drawer'


	getDefaultProps: ->
		user: {}

	render: ->
		isLogged = @props.user.id
		items = [
			@_createItem 'Home', 'home', 'person', @props.handleLogoutClick
			React.DOM.div key: 'spacer', className: 'nav-spacer'
		]
		content = [
			React.DOM.i
				key: 'ico-person'
				className: 'material-icons', if isLogged then 'person' else 'person_outline'
		]

		if isLogged
			content.push React.DOM.div
				key: 'drawer-username'
				className: 'drawer-username'
			, @props.user.displayName
			items.push @_createItem 'Logout', 'exit_to_app', 'exit_to_app', @props.handleLogoutClick
		else
			content.push React.DOM.a
				key: 'drawer-username'
				className: 'drawer-username button'
				href: '/login/facebook'
			, 'Facebook Login'

		React.DOM.div
			key: 'drawer'
			className: 'drawer'
		, [
			React.DOM.header
				key: 'drawer-header'
				className: 'drawer-header'
			, content
			React.DOM.nav
				key: 'drawer-nav'
				className: 'drawer-nav'
			, items
		]

	_createItem: (text, key, ico, handler) ->
		React.DOM.a
			key: key
			className: 'nav-item button'
			onClick: handler
		, [
			React.DOM.i
				key: ico
				className: 'material-icons', ico
		, text
		]


module.exports = connect(appState, dispatchToProps) drawer
