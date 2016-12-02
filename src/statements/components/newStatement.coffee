React = require 'react'
{connect} = require 'react-redux'
{addStatement} = require('../actions')


dispatchToProps = (dispatch) ->
	handleSave: ({parentId, text, agree}) ->
		dispatch addStatement parentId, text, agree



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
				value: if @state.agree then 'agree' else 'disagree'
				onChange: (e) => return @setState agree: e.target.value is 'agree'
			, [
				React.DOM.option
					key: "new-statement-select-option-app-#{id}"
					value: 'agree'
				, 'Agree'
			,
				React.DOM.option
					key: "new-statement-select-option-rej-#{id}"
					value: 'disagree'
				, 'Reject'
			]
			React.DOM.button
				key: "new-statement-button-#{id}"
				onClick: =>
					newStatement =
						text: @state.text
						agree: if @props.parentId then @state.agree else null
						parentId: @props.parentId ? null
					@setState isAdding: no, @props.handleSave.bind @, newStatement
			, 'Add'
		]


	getInitialState: ->
		text: ''
		agree: no
		isAdding: no

	getDefaultProps: ->
		parentId: null
		handleClickSave: ->


module.exports = connect(null, dispatchToProps) statement

