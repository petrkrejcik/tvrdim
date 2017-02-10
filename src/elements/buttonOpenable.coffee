React = require 'react'
Button = React.createFactory require './button'


module.exports = React.createClass

	displayName: 'ButtonOpenable'

	propTypes:
		text: React.PropTypes.string
		cssClasses: React.PropTypes.array

	getDefaultProps: ->
		text: ''
		handleClick: ->
		cssClasses: []

	getInitialState: ->
		isOpened: no

	render: ->
		cssClasses = @props.cssClasses.concat ['button-openable']
		hiddenButtons = if @state.isOpened then @props.children else null
		hidden = React.DOM.div className: 'button-openable--hidden', hiddenButtons
		React.DOM.div className: cssClasses.join(' '), [
			hidden
			Button
				text: @props.text
				handleClick: =>
					console.info 'click'
					@setState isOpened: !@state.isOpened
		]
