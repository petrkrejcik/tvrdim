React = require 'react'
{connect} = require 'react-redux'
{openDrawer} = require '../../layout/actions'

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
			className: 'header'
		, [
			React.DOM.div
				className: 'drawer-button'
				onClick: @props.handleOpenMenuClick
			, React.DOM.i className: 'material-icons', 'more_vert'
			React.DOM.div className: 'row', [
				React.DOM.span className: 'search', 'Search'
			]
		]

module.exports = connect(appState, dispatchToProps) header
