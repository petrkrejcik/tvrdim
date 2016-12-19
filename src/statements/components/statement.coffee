React = require 'react'
layoutActions = require '../../layout/actions'
{connect} = require 'react-redux'
{addStatement} = require '../actions'
{open, close, openRoot, storeTopOffset, openParent} = layoutActions

appState = (state) ->
	statements: state.statements
	tree: state.statementsTree
	opened: state.layout.statements.opened

dispatchToProps = (dispatch) ->

	handleOpenChild: (statement, top) ->
		dispatch open statement, top

	handleOpenRootParent: ->
		dispatch openRoot()

	handleOpenParent: ->
		statement = @props.statements[@props.ancestor]
		dispatch openParent statement

	handleSave: ({statementId, text, agree}) ->
		dispatch addStatement statementId, text, agree

	handleStoreTopOffset: (offset) ->
		dispatch storeTopOffset offset



statement = React.createClass

	displayName: 'Statement'

	getDefaultProps: ->
		id: null
		text: ''
		depth: null
		score: null
		customClassNames: []
		tree: {}
		style: {}
		storeTopOffset: no

	render: ->
		cssClasses = ['statement']
		# if @props.score
		# 	if @props.score > 0
		# 		cssClasses.push 'approved'

		title = React.DOM.div className: 'title', key: 'title', "#{@props.text} (id: #{@props.id})"

		React.DOM.div
			className: (cssClasses.concat @props.customClassNames).join ' '
			style: @props.style
			ref: (@_self) =>
		, [
			title
			React.DOM.div key: 'buttons', className: 'actions', [
				@_renderShowArgumentsBtn()
				@_renderGoToParentBtn()
			]
		]

	componentDidMount: ->
		return unless @props.storeTopOffset
		style = window.getComputedStyle @_self
		bounce = @_self.getBoundingClientRect()
		marginTop = parseInt style.marginTop
		offset =
			top: @_self.offsetTop
			topViewport: bounce.top
			left: @_self.offsetLeft
			height: @_self.offsetHeight + marginTop
		@props.handleStoreTopOffset offset
		return

	_renderShowArgumentsBtn: ->
		return if @props.id is @props.opened
		childrenIds = @props.tree[@props.id] ? []
		count = childrenIds.length
		return @_renderAddArgumentBtn() unless count
		isOpened = @props.id is @props.opened
		React.DOM.button
			className: 'btn-showArguments button'
			key: 'btn-showArguments'
			onClick: =>
				statement = @props.statements[@props.id]
				self = ReactDOM.findDOMNode @ # TODO: use ref
				style = self.getBoundingClientRect()
				@props.handleOpenChild statement, self.getBoundingClientRect().top
		,	"Show arguments (#{count})"

	_renderGoToParentBtn: ->
		return unless @props.id is @props.opened
		if parent = @props.statements[@props.ancestor]
			onClick = @props.handleOpenParent.bind @, parent
		else
			onClick = @props.handleOpenRootParent.bind @
		React.DOM.button
			className: 'btn-goToParent button'
			key: 'btn-goToParent'
			onClick: onClick
		, 'Up'

	_renderAddArgumentBtn: ->
		React.DOM.button
			className: 'btn-addArguments button'
			key: 'btn-addArguments'
			onClick: =>
				statement = @props.statements[@props.id]
				self = ReactDOM.findDOMNode @ # TODO: use ref
				@props.handleOpenChild statement, self.offsetTop
		,	"Add argument"


module.exports = connect(appState, dispatchToProps) statement
