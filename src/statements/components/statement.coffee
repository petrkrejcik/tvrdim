React = require 'react'
{connect} = require 'react-redux'
{addStatement} = require '../actions'
newStatement = React.createFactory require './newStatement'
layoutActions = require '../../layout/actions'
{open, close, openRoot} = layoutActions


appState = (state) ->
	statements: state.statements
	tree: state.statementsTree
	opened: state.layout.statements.opened

dispatchToProps = (dispatch) ->

	handleOpen: (statement) ->
		dispatch open statement

	handleOpenRoot: ->
		dispatch openRoot()

	handleSave: ({statementId, text, agree}) ->
		dispatch addStatement statementId, text, agree



statement = React.createClass

	displayName: 'Statement'

	getInitialState: ->
		isAdding: no

	getDefaultProps: ->
		id: null
		text: ''
		depth: null
		score: null
		customClassNames: []
		tree: {}

	render: ->
		cssClasses = ['statement']
		if @props.score
			if @props.score > 0
				cssClasses.push 'approved'
		if @props.id is @props.opened
			cssClasses.push ['opened']
		# else
			# cssClasses.push "depth-#{@props.depth}"

		title = React.DOM.div className: 'title', key: 'title', "#{@props.text} (id: #{@props.id})"

		React.DOM.div
			'className': (cssClasses.concat @props.customClassNames).join ' '
		, [
			title
			React.DOM.div key: 'buttons', className: 'actions', [
				@_renderShowArgumentsBtn()
				@_renderGoToParentBtn()
			]
		]

	_renderShowArgumentsBtn: ->
		return if @props.id is @props.opened
		childrenIds = @props.tree[@props.id] ? []
		count = childrenIds.length
		return @_renderAddArgumentBtn() unless count
		isOpened = @props.id is @props.opened
		React.DOM.button
			className: 'btn-showArguments button'
			key: 'btn-showArguments'
			onClick: @props.handleOpen.bind @, @props
		,	"Show arguments (#{count})"

	_renderAddArgumentBtn: ->
		React.DOM.button
			className: 'btn-addArguments button'
			key: 'btn-addArguments'
			onClick: @props.handleOpen.bind @, @props
		,	"Add argument"

	_renderGoToParentBtn: ->
		return unless @props.id is @props.opened
		if parent = @props.statements[@props.ancestor]
			onClick = @props.handleOpen.bind @, parent
		else
			onClick = @props.handleOpenRoot.bind @
		React.DOM.button
			className: 'btn-goToParent button'
			key: 'btn-goToParent'
			onClick: onClick
		,	'Up'


module.exports = connect(appState, dispatchToProps) statement
