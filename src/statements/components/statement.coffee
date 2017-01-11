React = require 'react'
{connect} = require 'react-redux'
newStatement = React.createFactory require './newStatement'
layoutActions = require '../../layout/actions'
{addStatement, remove} = require '../actions'
{open, close, openRoot} = layoutActions


dispatchToProps = (dispatch) ->

	handleOpen: (ancestorId) ->
		dispatch open ancestorId

	handleOpenRoot: ->
		dispatch openRoot()

	handleSave: ({statementId, text, agree}) ->
		dispatch addStatement statementId, text, agree

	handleRemove: (id, ancestor) ->
		dispatch remove id, ancestor



statement = React.createClass

	displayName: 'Statement'

	getInitialState: ->
		isAdding: no

	getDefaultProps: ->
		id: null
		isMine: null
		ancestor: null
		text: ''
		depth: null
		score: 0
		customClassNames: []
		isOpened: no
		childrenCount: 0

	render: ->
		cssClasses = ['statement']
		if @props.score
			if @props.score > 0
				cssClasses.push 'approved'
		if @props.isOpened
			cssClasses.push ['opened']
		# else
			# cssClasses.push "depth-#{@props.depth}"

		idDebug = ''
		idDebug = "(id: #{@props.id})" if no
		title = React.DOM.span className: 'title', key: 'title', "#{@props.text}#{idDebug}"

		React.DOM.div
			className: (cssClasses.concat @props.customClassNames).join ' '
		, [
			React.DOM.div
				key: 'top'
				className: 'top'
			, [
				title
				@_renderRemoveBtn()
			]
			@_renderBar()
			React.DOM.div key: 'buttons', className: 'actions', [
				@_renderGoToParentBtn()
				@_renderShowArgumentsBtn()
			]
		]

	_renderBar: ->
		piece = @props.childrenCount
		style = {}
		if @props.score is 0
			cssNeutral = 'neutral'
		else
			if @props.score > 0
				width = 100
			else
				width = 0
			style = width: "#{width}%"
		React.DOM.div key: 'bar', className: "bar #{cssNeutral}",
			React.DOM.div key: 'bar-accept', className: 'bar accept', style: style

	_renderRemoveBtn: ->
		return null unless @props.isMine
		React.DOM.span
			key: 'remove'
			className: 'remove button button-narrow'
			onClick: @props.handleRemove.bind @, @props.id, @props.ancestor
		, React.DOM.i
			key: 'icon-vert'
			className: 'material-icons', 'delete'


	_renderShowArgumentsBtn: ->
		return if @props.isOpened
		if count = @props.childrenCount
			text = "Show arguments (#{count})"
		else
			text = 'Add argument'
		React.DOM.button
			className: 'btn-showArguments button'
			key: 'btn-showArguments'
			onClick: @props.handleOpen.bind @, @props.id
		,	text

	_renderAddBtn: ->
		return if @props.isOpened
		React.DOM.button
			className: 'btn-addArguments button'
			key: 'btn-addArguments'
			onClick: @props.handleOpen.bind @, @props.id
		, "Add argument"

	_renderGoToParentBtn: ->
		return unless @props.isOpened
		if @props.ancestor
			onClick = @props.handleOpen.bind @, @props.ancestor
		else
			onClick = @props.handleOpenRoot.bind @
		React.DOM.button
			className: 'btn-goToParent button'
			key: 'btn-goToParent'
			onClick: onClick
		,	'Up'


module.exports = connect(null, dispatchToProps) statement
