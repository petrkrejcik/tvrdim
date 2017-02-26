React = require 'react'
{connect} = require 'react-redux'
layoutActions = require '../../layout/actions'
{remove, update} = require '../actions'
{open, close, openRoot, openMenu, closeMenu} = layoutActions
Menu = React.createFactory require './statementMenu'
Bar = React.createFactory require './bar'
{Link} = require 'react-router-dom'
Link = React.createFactory Link


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

	propTypes:
		childrenCountable: React.PropTypes.array
		isMenuOpened: React.PropTypes.bool
		isPrivate: React.PropTypes.bool
		ancestor: React.PropTypes.string

	getDefaultProps: ->
		id: null
		isMine: null
		ancestor: null
		text: ''
		depth: null
		score: 0
		customClassNames: []
		isOpened: no
		childrenCountable: []
		isPrivate: no

	getInitialState: ->
		text: ''
		isMenuOpened: no
		isPrivate: @props.isPrivate

	render: ->
		cssClasses = ['statement']
		if @props.score
			if @props.score > 0
				cssClasses.push 'approved'
		if @props.isOpened
			cssClasses.push ['opened']

		idDebug = ''
		idDebug = "(id: #{@props.id})" if no
		title = React.DOM.span className: 'title', key: 'title', "#{@props.text}#{idDebug}"

		Link to: "/that/#{@props.id}",
			React.DOM.div
				className: (cssClasses.concat @props.customClassNames).join ' '
				href: "/that/#{@props.id}"
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
				React.DOM.div key: 'buttons', className: 'actions'
			]

	_renderMenuButton: ->
		return null unless @props.isMine
		return null unless @props.isOpened
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

	_renderBar: ->
		Bar
			key: 'bar'
			score: @props.score
			agreeCount: @props.childrenCountable.filter((child) -> !!child.agree).length
			disagreeCount: @props.childrenCountable.filter((child) -> !child.agree).length



module.exports = connect(appState, dispatchToProps) statement
