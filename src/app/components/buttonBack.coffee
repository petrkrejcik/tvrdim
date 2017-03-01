React = require 'react'
Button = React.createFactory require '../../elements/button'


module.exports = React.createClass

	displayName: 'ButtonBack'

	contextTypes: goBack: React.PropTypes.func

	render: ->
		Button
			handleClick: @context.goBack
		, [
			React.DOM.i
				key: 'back-ico'
				className: 'material-icons', 'navigate_before'
			React.DOM.span key: 'back', 'Back'
		]

