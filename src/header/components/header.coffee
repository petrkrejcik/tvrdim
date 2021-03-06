React = require 'react'
{connect} = require 'react-redux'
{openDrawer} = require '../../layout/actions'
{Link} = require 'react-router-dom'
Link = React.createFactory Link

appState = (state) ->
	{}

dispatchToProps = (dispatch) ->
	handleOpenMenuClick: ->
		dispatch openDrawer()


header = React.createClass

	displayName: 'Header'


	getDefaultProps: ->
		{}

	render: ->
		React.DOM.header
			key: 'header'
			className: 'header'
		, [
			Link
				key: 'logo'
				className: 'logo'
				to: '/'
			, 'Tvrdim'
			React.DOM.div
				key: 'drawer-button'
				className: 'drawer-button'
				onClick: @props.handleOpenMenuClick
			, React.DOM.i
				key: 'icon-vert'
				className: 'material-icons', 'menu'
			# React.DOM.div
			# 	key: 'row'
			# 	className: 'row', [
			# 		# React.DOM.span
			# 		# 	key: 'search'
			# 		# 	className: 'search', 'Search'
			# 	]
		]

module.exports = connect(appState, dispatchToProps) header
