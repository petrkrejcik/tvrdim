React = require 'react'
{connect} = require 'react-redux'
{closeDrawer} = require '../../layout/actions'

appState = (state) ->
	drawer: state.layout.drawer

dispatchToProps = (dispatch) ->
	handleCloseDrawerClick: ->
		dispatch closeDrawer()


drawerOverlay = React.createClass

	displayName: 'DrawerOverlay'


	getDefaultProps: ->
		{}

	render: ->
		cssClasses = ['drawerOverlay']
		cssClasses.push 'visible' if @props.drawer.isOpened

		React.DOM.div
			className: cssClasses.join ' '
			onClick: @props.handleCloseDrawerClick

module.exports = connect(appState, dispatchToProps) drawerOverlay
