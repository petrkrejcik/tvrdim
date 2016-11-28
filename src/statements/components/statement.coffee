React = require 'react'
{connect} = require 'react-redux'
{addStatement, getDirectChildren} = require '../actions'
newStatement = React.createFactory require './newStatement'
layoutActions = require '../../layout/actions'
{toggleVisibility} = layoutActions


appState = (state) ->
	tree: state.statementsTree
	opened: state.layout.statements.opened

dispatchToProps = (dispatch) ->
	handleToggleChildren: (statementId, isPos, childrenIds) ->
		dispatch toggleVisibility statementId, isPos
		dispatch getDirectChildren childrenIds

	handleSave: ({statementId, text, isPos}) ->
		dispatch addStatement statementId, text, isPos



statement = React.createClass

	displayName: 'Statement'

	getInitialState: ->
		isAdding: no

	getDefaultProps: ->
		id: null
		text: ''
		depth: null
		score: null
		customClassNames: []
		tree: {}

	render: ->
		cssClasses = ['statement']
		if @props.score
			if @props.score > 0
				cssClasses.push 'approved'
			else
				cssClasses.push 'rejected'
		if isRoot = !@props.depth
			cssClasses.push ['root']
		else
			cssClasses.push "depth-#{@props.depth}"

		addNew = newStatement
			key: 'addNew'
			parentId: @props.id

		title = React.DOM.div className: 'title', key: 'title', "#{@props.text}"

		React.DOM.div
			'className': (cssClasses.concat @props.customClassNames).join ' '
		, [
			title
			@props.depth
			@_renderChildrenButton yes
			@_renderChildrenButton no
			addNew
			"(id: #{@props.id})"
		]

	_renderChildrenButton: (isPos) ->
		cssClasses = ['childrenToggle']
		cssClasses.push 'positive' if isPos
		childrenCount = @props.tree[@props.id]?.length ? 0

		React.DOM.div
			key: "children-btn-#{@props.id}-#{isPos}"
			className: cssClasses.join ' '
			onClick: =>
				return unless childrenCount
				@props.handleToggleChildren @props.id, isPos, @props.tree[@props.id]
		, "(#{childrenCount})"



module.exports = connect(appState, dispatchToProps) statement
