React = require 'react'
{connect} = require 'react-redux'
{toggleVisibility} = require '../../actions/index'


dispatchToProps = (dispatch) ->
	handleStatementClick: (statementId, isPos) ->
		dispatch toggleVisibility statementId, isPos



statement = React.createFactory React.createClass

	displayName: 'Statement'

	createChildBtn: (isPos = no) ->
		cssClasses = ['childrenToggle']
		if isPos
			cssClasses.push 'positive' if isPos
			childrenCount = @props['childrenPos'].length
			text = "+(#{childrenCount})"
			key = 'togglePos'
		else
			childrenCount = @props['childrenNeg'].length
			text = "-(#{childrenCount})"
			key = 'toggleNeg'

		React.DOM.div
			'key': key
			'className': cssClasses.join ' '
			'onClick': => @props['handleStatementClick'] @props.id, isPos
		, text

	render: ->
		if @props['isPosOpened']
			childrenPos = @props.listFactory
				statements: @props.childrenPos
				nestedType: 'positive'
		if @props['isNegOpened']
			childrenNeg = @props.listFactory
				statements: @props.childrenNeg
				nestedType: 'negative'

		React.DOM.div
			'className': 'statement'
		, [
			@props.text
			@createChildBtn yes
			@createChildBtn()
			childrenPos
			childrenNeg
		]

	getDefaultProps: ->
		'id': null
		'text': ''
		'isPosOpened': no
		'isNegOpened': no
		'childrenPos': []
		'childrenNeg': []
		'listFactory': ->


module.exports = connect(null, dispatchToProps) statement
