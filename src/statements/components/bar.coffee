React = require 'react'

module.exports = React.createClass

	displayName: 'Bar'

	propTypes:
		score: React.PropTypes.number.isRequired
		agreeCount: React.PropTypes.number.isRequired
		disagreeCount: React.PropTypes.number.isRequired
		customClassNames: React.PropTypes.array

	getDefaultProps: ->
		score: 0
		agreeCount: 0
		disagreeCount: 0
		customClassNames: []

	render: ->
		cssClasses = ['bar']
		cssClasses.push 'neutral' unless hasChildren = @props.agreeCount + @props.disagreeCount

		React.DOM.div
			className: 'bar-container'
		, [
			React.DOM.div key: 'num-agree', className: 'num agree', @props.agreeCount
			React.DOM.div
				key: 'bar'
				className: (cssClasses.concat @props.customClassNames).join ' '
			, @_renderAgreeColor()
			React.DOM.div key: 'num-disagree', className: 'num disagree', @props.disagreeCount
		]

	_renderAgreeColor: ->
		return unless hasChildren = @props.agreeCount + @props.disagreeCount
		width = @_countPositiveWidth @props.score, @props.agreeCount, @props.disagreeCount
		React.DOM.div
			key: 'positive'
			className: 'positive'
			style: width: "#{width}%"

	_countPositiveWidth: (score, agreeCount, disagreeCount) ->
		return 50 if score is 0
		total = agreeCount + disagreeCount
		piece = 100 / total
		if score > 0
			width = (total - score) * piece
		else
			width = (total + score) * piece
		Math.floor width
