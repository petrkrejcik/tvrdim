React = require 'react'
{connect} = require 'react-redux'
{addStatement, getDirectChildren} = require '../actions'
newStatement = React.createFactory require './newStatement'
layoutActions = require '../../layout/actions'
{toggleVisibility} = layoutActions


appState = (state) ->
	statements: state.statements
	tree: state.statementsTree
	opened: state.layout.statements.opened

dispatchToProps = (dispatch) ->
	handleToggleChildren: (statementId, isApproving, open) ->
		dispatch toggleVisibility statementId, isApproving, open

	handleSave: ({statementId, text, isApproving}) ->
		dispatch addStatement statementId, text, isApproving



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
			@_renderChildrenButton yes
			@_renderChildrenButton no
			addNew
			"(id: #{@props.id})"
		]

	_renderChildrenButton: (isApproving) ->
		cssClasses = ['childrenToggle']
		cssClasses.push 'approving' if isApproving
		children = @props.tree[@props.id].filter (childId) => @props.statements[childId].isApproving is isApproving
		childrenCount = children.length
		openedKey = if isApproving then 'approving' else 'rejecting'
		isOpened = @props.id in @props.opened[openedKey]


		React.DOM.div
			key: "children-btn-#{@props.id}-#{isApproving}"
			className: cssClasses.join ' '
			onClick: =>
				return unless childrenCount
				@props.handleToggleChildren @props.id, isApproving, !isOpened
		, "#{openedKey}: (#{childrenCount})"



module.exports = connect(appState, dispatchToProps) statement
