React = require 'react'
{connect} = require 'react-redux'
{addStatement} = require '../actions'
newStatement = React.createFactory require './newStatement'
layoutActions = require '../../layout/actions'
{toggleVisibility} = layoutActions


appState = (state) ->
	statements: state.statements
	tree: state.statementsTree
	opened: state.layout.statements.opened

dispatchToProps = (dispatch) ->
	handleToggleChildren: (statementId, agree, open) ->
		dispatch toggleVisibility statementId, agree, open

	handleSave: ({statementId, text, agree}) ->
		dispatch addStatement statementId, text, agree



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
				cssClasses.push 'agree'
			else
				cssClasses.push 'disagree'
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
			"(id: #{@props.id})"
			addNew
			@_renderChildrenButton yes
			@_renderChildrenButton no
		]

	_renderChildrenButton: (agree) ->
		cssClasses = ['childrenToggle']
		cssClasses.push 'agree' if agree
		childrenIds = @props.tree[@props.id] ? []
		children = childrenIds.filter (childId) => @props.statements[childId].agree is agree
		childrenCount = children.length
		openedKey = if agree then 'agree' else 'disagree'
		isOpened = @props.id in @props.opened[openedKey]


		React.DOM.div
			key: "children-btn-#{@props.id}-#{agree}"
			className: cssClasses.join ' '
			onClick: =>
				return unless childrenCount
				@props.handleToggleChildren @props.id, agree, !isOpened
		, "#{openedKey}: (#{childrenCount})"



module.exports = connect(appState, dispatchToProps) statement
