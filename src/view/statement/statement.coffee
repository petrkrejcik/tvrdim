React = require 'react'


module.exports = React.createFactory React.createClass

	render: ->
		React.DOM.div
			'className': 'statement'
		, @props.text


