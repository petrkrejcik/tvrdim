React = require 'react'
{connect} = require 'react-redux'
statementList = React.createFactory require './statementList'
newStatement = React.createFactory require './newStatement'
{ANIMATION_START, ANIMATION_END} = require '../../util/consts'

appState = (state) ->
	tree: state.statementsTree
	statements: state.statements
	openedStatementId: state.layout.statements.opened
	openedTop: state.layout.statements.openedTop
	animationOpen: state.layout.statements.animationOpen


list = React.createClass

	displayName: 'ChildrenStatementList'


	getDefaultProps: ->
		statementIds: []
		cssClasses: []
		isEntering: no

	render: ->
		style = {}
		cssClasses = ['children']
		parentId = @props.openedStatementId
		childrenIds = @props.tree[@props.openedStatementId] ? []
		agrees = childrenIds.filter (id) => @props.statements[id].agree
		disagrees = childrenIds.filter (id) => !@props.statements[id].agree

		unless @props.animationOpen
			cssClasses.push 'appear'
			style = top: "#{@props.openedTop - 6}px" # TODO: add padding variable
		else if @props.animationOpen is ANIMATION_START
			cssClasses.push 'enter'
			style = top: "#{@props.openedTop - 6}px" # TODO: add padding variable
		else
			cssClasses.push 'visible'


		React.DOM.div
			className: cssClasses.join ' '
			style: style
		, [
			@_renderChildren disagrees, parent.id, no
			@_renderChildren agrees, parent.id, yes
		]

	_renderChildren: (childrenIds, parentId, agree) ->
		cssClass = if agree then 'agree' else 'disagree'
		emptyStatement = newStatement
			key: 'empty-statement'
			agree: agree
			parentId: parentId

		React.DOM.div
			className: "children-#{cssClass}"
		, [
			# emptyStatement
			statementList
				statementIds: childrenIds
				cssClasses: [cssClass]
				isEntering: @props.isEntering
		]



module.exports = connect(appState) list
