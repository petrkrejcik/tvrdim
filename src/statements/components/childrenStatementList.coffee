React = require 'react'
{connect} = require 'react-redux'
{ANIMATION_START, ANIMATION_END} = require '../../util/consts'
statementList = React.createFactory require './statementList'
newStatement = React.createFactory require './newStatement'

appState = (state) ->
	tree: state.statementsTree
	statements: state.statements
	openedStatementId: state.layout.statements.opened
	firstOffset: state.layout.statements.firstOffset
	animationOpenChild: state.layout.statements.animationOpenChild


list = React.createClass

	displayName: 'ChildrenStatementList'


	getDefaultProps: ->
		statementIds: []
		cssClasses: []
		listCssClasses: []
		isEntering: no
		childrenIds: []
		parent: null
		style: {}

	render: ->
		cssClasses = ['children']
		agrees = @props.childrenIds.filter (id) => @props.statements[id].agree
		disagrees = @props.childrenIds.filter (id) => !@props.statements[id].agree

		React.DOM.div
			className: cssClasses.join ' '
			style: @props.style
		, [
			@_renderChildren disagrees, no
			@_renderChildren agrees, yes
		]

	_renderChildren: (childrenIds, agree) ->
		cssClass = if agree then 'agree' else 'disagree'
		cssClasses = @props.listCssClasses.concat cssClass
		emptyStatement = newStatement
			key: 'empty-statement'
			agree: agree
			parentId: @props.parent.id

		React.DOM.div
			className: "children-#{cssClass}"
		, [
			# emptyStatement
			statementList
				statementIds: childrenIds
				cssClasses: cssClasses
				isEntering: @props.isEntering
		]



module.exports = connect(appState) list
