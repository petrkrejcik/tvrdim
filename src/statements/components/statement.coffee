React = require 'react'
{connect} = require 'react-redux'
{addStatement} = require '../actions'
layoutActions = require '../../layout/actions'
{toggleVisibility} = layoutActions


dispatchToProps = (dispatch) ->
	handleToggleChildren: (statementId, isPos) ->
		dispatch toggleVisibility statementId, isPos

	handleSave: ({statementId, text, isPos}) ->
		dispatch addStatement statementId, text, isPos


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

newStatement = React.createFactory React.createClass

	displayName: 'NewStatement'

	render: ->
		React.DOM.div
			key: "new-statement-#{@props.id}"
			className: 'newStatement'
		, [
			React.DOM.input
				key: "new-statement-input-#{@props.id}"
				placeholder: 'Add new'
				value: @state.text
				onChange: (e) => return @setState text: e.target.value
			React.DOM.select
				key: "new-statement-select-#{@props.id}"
				value: if @state.isPos then 'positive' else 'negative'
				onChange: (e) => return @setState isPos: e.target.value is 'positive'
			, [
				React.DOM.option
					key: "new-statement-select-option-pos-#{@props.id}"
					value: 'positive'
				, 'Positive'
			,
				React.DOM.option
					key: "new-statement-select-option-neg-#{@props.id}"
					value: 'negative'
				, 'Negative'
			]
			React.DOM.button
				key: "new-statement-button-#{@props.id}"
				onClick: => return @props.handleClickSave @state
			, 'Add'
		]


	getInitialState: ->
		text: ''
		isPos: no

	getDefaultProps: ->
		id: null
		handleClickSave: ->


statement = React.createClass

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

		posButton = childrenButton
			key: "togglePos-#{@props.id}"
			isPos: yes
			childrenCount: @props['childrenPos'].length
			handleClick: => @props.handleToggleChildren @props.id, yes

		negButton = childrenButton
			key: "toggleNeg-#{@props.id}"
			childrenCount: @props['childrenNeg'].length

		newStatementText = unless @props.isAdding
			React.DOM.span
				key: "add-statement-#{@props.id}"
				className: 'statement-newButton'
				onClick: => @setState isAdding: yes
			, 'Add new'

		newButton = if @state.isAdding
			newStatement
				id: @props.id
				handleClickSave: (values) =>
					values.statementId = @props.id
					@props.handleSave values
					return


		React.DOM.div
			'className': 'statement'
		, [
			@props.text
			posButton
			newStatementText
			negButton
			newButton
			childrenPos
			childrenNeg
		]

	getInitialState: ->
		isAdding: no

	getDefaultProps: ->
		id: null
		text: ''
		isPosOpened: no
		isNegOpened: no
		childrenPos: []
		childrenNeg: []
		listFactory: ->
		handleClickSave: ->


module.exports = connect(null, dispatchToProps) statement
