React = require 'react'
{connect} = require 'react-redux'
{addStatement} = require '../actions'
Menu = React.createFactory require './statementMenu'


appState = (state) ->
	user: state.user

dispatchToProps = (dispatch) ->
	handleSave: ({ancestor, text, agree, user, isPrivate}) ->
		dispatch addStatement ancestor, text, agree, user.id, isPrivate



statement = React.createClass

	displayName: 'NewStatement'

	getDefaultProps: ->
		ancestor: null
		agree: null
		user: {}
		isPrivate: no
		handleClickSave: ->

	getInitialState: ->
		text: ''
		isMenuOpened: no
		isPrivate: @props.isPrivate

	render: ->
		btnClass = ['button button-raised']
		btnClass.push ['button-colored'] if @state.text
		placeholder = if @props.agree
			'Yes, that\'s true, because ...'
		else if @props.ancestor then 'No, that\'s not true, because ...'
		else 'Add new statement...'

		React.DOM.div
			className: 'statement empty'
			onClick: => @setState isMenuOpened: yes
		, [
			React.DOM.div
				className: 'top'
				key: 'top'
			, [
				React.DOM.input
					key: 'input'
					placeholder: placeholder
					value: @state.text
					className: 'long'
					onChange: (e) => return @setState text: e.target.value
			]
		,
			@_renderMenu()
		]

	_renderMenu: ->
		return unless @state.isMenuOpened
		Menu
			key: 'menu'
			ancestor: @props.ancestor
			isPrivate: @state.isPrivate
			handleSave: @_handleSave
			saveButtonEnabled: !!@state.text
			handlePrivateChange: => @setState isPrivate: !@state.isPrivate

	_handleSave: ->
		return unless @state.text
		newStatement =
			text: @state.text
			agree: @props.agree
			ancestor: @props.ancestor
			user: @props.user
		newStatement.isPrivate = @state.isPrivate unless @props.ancestor # save isPrivate only for root
		@props.handleSave newStatement
		@setState text: '', isMenuOpened: no
		return

module.exports = connect(appState, dispatchToProps) statement

