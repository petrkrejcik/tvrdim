React = require 'react'
{connect} = require 'react-redux'
{addStatement} = require('../actions')


dispatchToProps = (dispatch) ->
	handleSave: ({parentId, text, isPos}) ->
		dispatch addStatement parentId, text, isPos



statement = React.createClass

	displayName: 'NewStatement'

	render: ->
		id = @props.parentId ? 'root'
		unless @state.isAdding
			return React.DOM.span
				key: "add-statement-#{id}"
				className: 'statement-newButton'
				onClick: => @setState isAdding: yes
			, 'Add new'


		React.DOM.div
			key: "new-statement-#{id}"
			className: 'newStatement'
		, [
			React.DOM.input
				key: "new-statement-input-#{id}"
				placeholder: 'Add new'
				value: @state.text
				onChange: (e) => return @setState text: e.target.value
			React.DOM.select
				key: "new-statement-select-#{id}"
				value: if @state.isPos then 'positive' else 'negative'
				onChange: (e) => return @setState isPos: e.target.value is 'positive'
			, [
				React.DOM.option
					key: "new-statement-select-option-pos-#{id}"
					value: 'positive'
				, 'Positive'
			,
				React.DOM.option
					key: "new-statement-select-option-neg-#{id}"
					value: 'negative'
				, 'Negative'
			]
			React.DOM.button
				key: "new-statement-button-#{id}"
				onClick: =>
					newStatement =
						text: @state.text
						isPost: @state.isPos
						parentId: @props.parentId ? null
					@setState isAdding: no, @props.handleSave.bind @, newStatement
			, 'Add'
		]


	getInitialState: ->
		text: ''
		isPos: no
		isAdding: no

	getDefaultProps: ->
		parentId: null
		handleClickSave: ->


module.exports = connect(null, dispatchToProps) statement

