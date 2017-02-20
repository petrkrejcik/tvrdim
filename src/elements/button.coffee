React = require 'react'

module.exports = React.createClass

	propTypes:
		text: React.PropTypes.string
		cssClasses: React.PropTypes.array

	getDefaultProps: ->
		text: ''
		cssClasses: []
		handleClick: ->

	render: ->
		cssClasses = ['button']
		React.DOM.button
			className: cssClasses.concat(@props.cssClasses).join ' '
			onClick: @props.handleClick
		, @props.text
