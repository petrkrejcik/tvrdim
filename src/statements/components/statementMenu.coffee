React = require 'react'
{connect} = require 'react-redux'
layoutActions = require '../../layout/actions'
{addStatement, remove} = require '../actions'


dispatchToProps = (dispatch) ->

	handleRemove: (id, ancestor) ->
		dispatch remove id, ancestor



Menu = React.createClass

	displayName: 'Statement Menu'

	getDefaultProps: ->
		handlePrivateChange: ->

	propTypes:
		ancestor: React.PropTypes.string
		id: React.PropTypes.string
		isMine: React.PropTypes.bool
		isPrivate: React.PropTypes.bool
		saveButtonEnabled: React.PropTypes.bool
		showSaveButton: React.PropTypes.bool

	render: ->
		React.DOM.div
			className: 'statementMenu'
		, [
			React.DOM.div
				key: 'column1'
				className: 'column'
			, [
				@_renderPrivateCheckbox()
			]
		,
			React.DOM.div
				key: 'buttons'
				className: 'buttons column'
			, [
				@_renderRemoveBtn()
				@_renderSaveButton()
			]
		]

	_renderPrivateCheckbox: ->
		cssClasses = ['private']
		cssClasses.push 'disabled' if @props.ancestor
		React.DOM.div
			key: 'private'
			className: cssClasses.join ' '
			onClick: @_handleIsPrivateToggle
		, [
			React.DOM.input
				key: 'checkbox'
				type: 'checkbox'
				readOnly: yes
				checked: @props.isPrivate
				disabled: !!@props.ancestor
		,
			React.DOM.span
				key: 'privateLabel'
				className: 'label'
			, 'Private'
		]

	_renderSaveButton: ->
		btnClass = ['button button-raised']
		btnClass.push ['button-colored'] if @props.saveButtonEnabled
		React.DOM.button
			key: 'save'
			className: btnClass.join ' '
			onClick: @_handleSave
		, 'Save'

	_renderRemoveBtn: ->
		return null unless @props.isMine
		React.DOM.button
			key: 'remove'
			className: 'button'
			onClick: @_handleRemoveClick
		, 'Remove'

	_handleIsPrivateToggle: ->
		return if @props.ancestor
		@props.handlePrivateChange()
		return

	_handleRemoveClick: ->
		if confirm 'Delete statement?'
			@props.handleRemove @props.id, @props.ancestor
		return

	_handleSave: (e) ->
		e.stopPropagation()
		@props.handleSave()
		return

module.exports = connect(null, dispatchToProps) Menu
