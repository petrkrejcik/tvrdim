React = require 'react'
{connect} = require 'react-redux'
statement = React.createFactory require './statement'
statementList = React.createFactory require './statementList'
{openDrawer} = require '../../layout/actions'
{ANIMATION_START, ANIMATION_END, ANIMATION_HIDE_DURATION} = require '../../util/consts'


appState = (state) ->
	statements: state.statements
	opened: state.layout.statements.opened
	openedTop: state.layout.statements.openedTop
	animationOpen: state.layout.statements.animationOpen


list = React.createClass

	displayName: 'StatementOpened'

	getDefaultProps: ->
		statements: []
		tree: {}
		opened: null

	render: ->
		style = {}
		cssClasses = ['opened']
		parent = @props.statements[@props.opened]

		unless @props.animationOpen
			cssClasses.push 'appear'
			style = top: "#{@props.openedTop - 6}px" # TODO: add padding variable
		else if @props.animationOpen is ANIMATION_START
			cssClasses.push 'enter'
			style = top: "#{@props.openedTop - 6}px" # TODO: add padding variable
		else
			cssClasses.push 'visible'

		props = Object.assign {}, {style}, parent,
			key: "statement-#{parent.id}-opened"
			customClassNames: cssClasses

		statement props, key: "statement-#{parent.id}-opened"


module.exports = connect(appState) list
