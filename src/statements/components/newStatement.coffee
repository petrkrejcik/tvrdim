React = require 'react'
{connect} = require 'react-redux'
{addStatement} = require('../actions')


dispatchToProps = (dispatch) ->
	handleSave: ({parentId, text, isApproving}) ->
		dispatch addStatement parentId, text, isApproving



statement = React.createClass

	displayName: 'NewStatement'

	render: ->
		id = @props.parentId ? 'root'
		unless @state.isAdding
			return React.DOM.div
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
				value: if @state.isApproving then 'approving' else 'rejecting'
				onChange: (e) => return @setState isApproving: e.target.value is 'approving'
			, [
				React.DOM.option
					key: "new-statement-select-option-app-#{id}"
					value: 'approving'
				, 'Approving'
			,
				React.DOM.option
					key: "new-statement-select-option-rej-#{id}"
					value: 'rejecting'
				, 'Rejecting'
			]
			React.DOM.button
				key: "new-statement-button-#{id}"
				onClick: =>
					newStatement =
						text: @state.text
						isApproving: if @props.parentId then @state.isApproving else null
						parentId: @props.parentId ? null
					@setState isAdding: no, @props.handleSave.bind @, newStatement
			, 'Add'
		]


	getInitialState: ->
		text: ''
		isApproving: no
		isAdding: no

	getDefaultProps: ->
		parentId: null
		handleClickSave: ->


module.exports = connect(null, dispatchToProps) statement

