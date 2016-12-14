React = require 'react'
{connect} = require 'react-redux'
{addStatement} = require '../actions'


appState = (state) ->
	user: state.user

dispatchToProps = (dispatch) ->
	handleSave: ({parentId, text, agree, user}) ->
		dispatch addStatement parentId, text, agree, user.id



statement = React.createClass

	displayName: 'NewStatement'

	getDefaultProps: ->
		parentId: null
		agree: null
		handleClickSave: ->
		user: {}

	getInitialState: ->
		text: ''

	render: ->
		parentId = @props.parentId
		btnClass = ['button button-raised']
		btnClass.push ['button-colored'] if @state.text
		placeholder = if @props.agree
			'Yes, that\'s true, because ...'
		else if @props.parentId then 'No, that\'s not true, because ...'
		else 'Add new statement...'

		React.DOM.div
			key: "new-statement-#{parentId}"
			className: 'statement empty'
		, [
			React.DOM.input
				key: "new-statement-input-#{parentId}"
				placeholder: placeholder
				value: @state.text
				className: 'long'
				onChange: (e) => return @setState text: e.target.value
			React.DOM.button
				key: "new-statement-button-#{parentId}"
				className: btnClass.join ' '
				onClick: =>
					newStatement =
						text: @state.text
						agree: !!@props.agree
						parentId: @props.parentId
						user: @props.user
					@props.handleSave newStatement, @setState text: ''
					return
			, 'Add'
		]

module.exports = connect(appState, dispatchToProps) statement

