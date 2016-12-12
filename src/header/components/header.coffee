React = require 'react'
{connect} = require 'react-redux'

appState = (state) ->
	{}

header = React.createClass

	displayName: 'Header'


	getDefaultProps: ->
		{}

	render: ->
		React.DOM.header
			className: 'header'
		, [
			React.DOM.div className: 'drawer-button'
			React.DOM.div className: 'row', [
				React.DOM.span className: 'search', 'Search'
			]
		]

module.exports = connect(appState) header
