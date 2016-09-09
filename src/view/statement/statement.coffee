React = require 'react'
{connect} = require 'react-redux'
{toggleVisibility} = require '../../actions/index'


dispatchToProps = (dispatch) ->
	handleToggleChildren: (statementId, isPos) ->
		dispatch toggleVisibility statementId, isPos


childrenButton = React.createFactory React.createClass

	displayName: 'StatementChildButton'

	render: ->
		cssClasses = ['childrenToggle']
		cssClasses.push 'positive' if @props.isPos

		React.DOM.div
			className: cssClasses.join ' '
			onClick: => @props.handleClick @props.id, @props.isPos
		, "-(#{@props.childrenCount})"

	getDefaultProps: ->
		isPos: no
		childrenCount: null
		handleStatementClick: ->


statement = React.createFactory React.createClass

	displayName: 'Statement'

	render: ->
		if @props['isPosOpened']
			childrenPos = @props.listFactory
				statements: @props.childrenPos
				nestedType: 'positive'
				key: "nestedStatementList-pos-#{@props.id}"
		if @props['isNegOpened']
			childrenNeg = @props.listFactory
				statements: @props.childrenNeg
				nestedType: 'negative'
				key: "nestedStatementList-neg-#{@props.id}"

		React.DOM.div
			'className': 'statement'
		, [
			@props.text
			childrenButton
				key: "togglePos-#{@props.id}"
				isPos: yes
				childrenCount: @props['childrenPos'].length
				handleClick: => @props.handleToggleChildren @props.id, yes
			childrenButton
				key: "toggleNeg-#{@props.id}"
				childrenCount: @props['childrenNeg'].length
				handleClick: => @props.handleToggleChildren @props.id, no
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
