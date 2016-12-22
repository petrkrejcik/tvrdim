React = require 'react'
{connect} = require 'react-redux'
{addStatement} = require '../actions'


appState = (state) ->
	user: state.user

dispatchToProps = (dispatch) ->
	handleSave: ({ancestor, text, agree, user}) ->
		dispatch addStatement ancestor, text, agree, user.id



statement = React.createClass

	displayName: 'NewStatement'

	getDefaultProps: ->
		ancestor: null
		agree: null
		handleClickSave: ->
		user: {}

	getInitialState: ->
		text: ''


	render: ->
		ancestor = @props.ancestor
		btnClass = ['button button-raised']
		btnClass.push ['button-colored'] if @state.text
		placeholder = if @props.agree
			'Yes, that\'s true, because ...'
		else if @props.ancestor then 'No, that\'s not true, because ...'
		else 'Add new statement...'

		React.DOM.div
			key: "new-statement-#{ancestor}"
			className: 'statement empty'
		, [
			React.DOM.input
				key: "new-statement-input-#{ancestor}"
				placeholder: placeholder
				value: @state.text
				className: 'long'
				onChange: (e) => return @setState text: e.target.value
			React.DOM.button
				key: "new-statement-button-#{ancestor}"
				className: btnClass.join ' '
				onClick: =>
					return unless @state.text
					newStatement =
						text: @state.text
						agree: @props.agree
						ancestor: @props.ancestor
						user: @props.user
					@props.handleSave newStatement, @setState text: ''
					return
			, 'Add'
		]

module.exports = connect(appState, dispatchToProps) statement

