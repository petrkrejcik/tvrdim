React = require 'react'
{connect} = require 'react-redux'
layoutActions = require '../../layout/actions'
{addStatement, remove} = require '../actions'
{open, close, openRoot} = layoutActions


dispatchToProps = (dispatch) ->

	handleOpen: (ancestorId) ->
		dispatch open ancestorId

	handleRemove: (id, ancestor) ->
		dispatch remove id, ancestor



Menu = React.createClass

	displayName: 'Statement Menu'

	getDefaultProps: ->
		handlePrivateChange: ->

	propTypes:
		id: React.PropTypes.string
		isPrivate: React.PropTypes.bool
		showSaveButton: React.PropTypes.bool
		isMine: React.PropTypes.bool
		ancestor: React.PropTypes.string
		# handlePrivateChange: React.PropTypes.fn

	getInitialState: ->
		isPrivate: @props.isPrivate

	render: ->
		React.DOM.div
			className: 'statementMenu'
		, [
			React.DOM.div
				key: 'private'
				className: 'private'
				onClick: @_handleIsPrivateToggle
			, [
				React.DOM.input
					key: 'checkbox'
					type: 'checkbox'
					readOnly: yes
					checked: @state.isPrivate
			,
				React.DOM.span
					key: 'privateLabel'
					className: 'label'
				, 'Private'
			]
		,
			@_renderRemoveBtn()
			@_renderSaveButton()
		]

	_renderSaveButton: ->
		return unless @props.showSaveButton
		React.DOM.button
			key: 'save'
			className: ['button button-raised button-colored']
			onClick: @_handleSave
		, 'Save'

	_renderRemoveBtn: ->
		return null unless @props.isMine
		React.DOM.button
			key: 'remove'
			className: ['button button-raised']
			onClick: @_handleRemoveClick
		, 'Remove'

	_handleIsPrivateToggle: ->
		newState = !@state.isPrivate
		@setState isPrivate: newState, @props.handlePrivateChange.bind @, newState
		return

	_handleRemoveClick: ->
		if confirm 'Delete statement?'
			@props.handleRemove @props.id, @props.ancestor
		return

	_handleSave: =>
		return
		newStatement =
			text: @state.text
			agree: @props.agree
			ancestor: @props.ancestor
			user: @props.user
		@props.handleEdit newStatement, @setState text: ''
		return

module.exports = connect(null, dispatchToProps) Menu
