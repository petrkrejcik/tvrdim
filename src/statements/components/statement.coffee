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
		console.info 'childrenIds', childrenIds
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
		isPosOpened: no
		isNegOpened: no
		childrenPos: []
		childrenNeg: []
		tree: {}
		listFactory: ->
		handleClickSave: ->

	render: ->
		# if @props['isPosOpened']
		if @props.id in @props.opened.pos
			childrenPos = @props.listFactory
				nestedType: 'positive'
				vole: 'aaa'
				sortChildren: @props.tree[@props.id]
				key: "nestedStatementList-pos-#{@props.id}"
		if @props.id in @props.opened.neg
		# if @props['isNegOpened']
			childrenNeg = @props.listFactory
				nestedType: 'negative'
				sortChildren: @props.tree[@props.id]
				key: "nestedStatementList-neg-#{@props.id}"

		posButton = @_renderChildrenButton yes
		negButton = @_renderChildrenButton no

		addNew = newStatement
			key: 'addNew'
			parentId: @props.id

		React.DOM.div
			'className': 'statement'
		, [
			"#{@props.text} (id: #{@props.id})"
			posButton
			negButton
			addNew
			childrenPos
			childrenNeg
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
