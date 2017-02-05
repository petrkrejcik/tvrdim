React = require 'react'
{connect} = require 'react-redux'
layoutActions = require '../../layout/actions'
{remove, update} = require '../actions'
{open, close, openRoot, openMenu, closeMenu} = layoutActions
Menu = React.createFactory require './statementMenu'


dispatchToProps = (dispatch) ->

	handleOpen: (ancestorId) ->
		dispatch open ancestorId

	handleOpenRoot: ->
		dispatch openRoot()

	handleEdit: (data) ->
		dispatch update data

	handleRemove: (id, ancestor) ->
		dispatch remove id, ancestor

	handleMenuOpen: (id) ->
		dispatch openMenu id

	handleMenuClose: ->
		dispatch closeMenu()


appState = (state, {id}) ->
	isMenuOpened: id is state.layout.statements.menuOpened


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
		isPrivate: no

	getInitialState: ->
		text: ''
		isMenuOpened: no
		isPrivate: @props.isPrivate

	propTypes:
		childrenCount: React.PropTypes.number
		isMenuOpened: React.PropTypes.bool
		isPrivate: React.PropTypes.bool

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
		idDebug = "(id: #{@props.id})" if yes
		title = React.DOM.span className: 'title', key: 'title', "#{@props.text}#{idDebug}"

		React.DOM.div
			className: (cssClasses.concat @props.customClassNames).join ' '
		, [
			React.DOM.div
				key: 'top'
				className: 'top'
			, [
				title
				@_renderMenuButton()
			]
			@_renderMenu()
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

	_renderMenuButton: ->
		return null unless @props.isMine
		icon = if @props.isMenuOpened then 'expand_less' else 'expand_more'
		React.DOM.span
			key: 'menu'
			className: 'button button-narrow'
			onClick: @_handleMenuToggle
		, React.DOM.i
			key: 'expand-more'
			className: 'material-icons', icon

	_handleMenuToggle: ->
		if @props.isMenuOpened
			@props.handleMenuClose()
		else
			@props.handleMenuOpen @props.id
		return

	_renderMenu: ->
		return null unless @props.isMenuOpened
		Menu
			key: 'menu'
			id: @props.id
			isMine: @props.isMine
			ancestor: @props.ancestor
			isPrivate: @state.isPrivate
			handleSave: => @props.handleEdit
				id: @props.id
				text: @props.text
				isPrivate: @state.isPrivate
				ancestor: @props.ancestor
			handlePrivateChange: => @setState isPrivate: !@state.isPrivate

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


module.exports = connect(appState, dispatchToProps) statement
