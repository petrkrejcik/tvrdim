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
		handleClickSave: ->
		user: {}

	getInitialState: ->
		text: ''
		isMenuOpened: yes
		isPrivate: no

	render: ->
		ancestor = @props.ancestor
		btnClass = ['button button-raised']
		btnClass.push ['button-colored'] if @state.text
		placeholder = if @props.agree
			'Yes, that\'s true, because ...'
		else if @props.ancestor then 'No, that\'s not true, because ...'
		else 'Add new statement...'

		React.DOM.div
			className: 'statement empty'
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
					onFocus: => @setState isMenuOpened: yes
					# onBlur: => @setState isMenuOpened: no
				React.DOM.button
					key: 'add'
					className: btnClass.join ' '
					onClick: =>
						return unless @state.text
						newStatement =
							text: @state.text
							agree: @props.agree
							ancestor: @props.ancestor
							user: @props.user
							isPrivate: @state.isPrivate
						@props.handleSave newStatement, @setState text: ''
						return
				, 'Add'
			]
		,
			@_renderMenu()
		]

	_renderMenu: ->
		return unless @state.isMenuOpened
		Menu
			key: 'menu'
			isPrivate: @state.isPrivate
			handlePrivateChange: (isChecked) => @setState isPrivate: isChecked

module.exports = connect(appState, dispatchToProps) statement

