React = require 'react'

module.exports = React.createClass

	propTypes:
		text: React.PropTypes.string

	getDefaultProps: ->
		text: ''
		handleClick: ->

	render: ->
		React.DOM.button
			className: 'button button-fab button-colored'
			onClick: @props.handleClick
		, @props.text
