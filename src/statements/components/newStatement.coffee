React = require 'react'
{connect} = require 'react-redux'
{addStatement} = require '../actions'
Menu = React.createFactory require './statementMenu'
ButtonBack = React.createFactory require '../../app/components/buttonBack'


appState = (state, {match, location}) ->
	{id} = match.params
	ancestor: state.statements[id]
	user: state.user
	agree: location.state?.agree ? null

dispatchToProps = (dispatch) ->
	handleSave: ({ancestor, text, agree, user, isPrivate}) ->
		dispatch addStatement ancestor, text, agree, user.id, isPrivate



statement = React.createClass

	displayName: 'NewStatement'

	getChildContext: ->
		push: @props.push
		goBack: @props.goBack
	childContextTypes:
		push: React.PropTypes.func
		goBack: React.PropTypes.func

	propTypes:
		ancestor: React.PropTypes.object
		agree: React.PropTypes.bool

	getDefaultProps: ->
		agree: null
		user: {}
		isPrivate: no
		handleClickSave: ->

	getInitialState: ->
		text: ''
		isMenuOpened: yes
		isPrivate: @props.isPrivate

	render: ->
		btnClass = ['button button-raised']
		btnClass.push ['button-colored'] if @state.text
		placeholder = if @props.agree
			'Yes, that\'s true, because ...'
		else if @props.ancestor then 'No, that\'s not true, because ...'
		else 'Add new statement...'

		React.DOM.div {}, [
			ButtonBack key: 'back'
			React.DOM.div
				key: 'empty'
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
						ref: (input) => @input = input
						onChange: (e) => return @setState text: e.target.value
				]
			,
				@_renderMenu()
			]
		]

	componentDidMount: ->
		@input.focus()
		return

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
			ancestor: @props.ancestor?.id
			user: @props.user
		newStatement.isPrivate = @state.isPrivate unless @props.ancestor # save isPrivate only for root
		@props.handleSave newStatement
		@props.goBack()
		return

module.exports = connect(appState, dispatchToProps) statement

