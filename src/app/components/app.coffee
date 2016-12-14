React = require 'react'
statementList = React.createFactory require '../../statements/components/statementList'
childrenStatementList = React.createFactory require '../../statements/components/childrenStatementList'
statementOpened = React.createFactory require '../../statements/components/statementOpened'
newStatement = React.createFactory require '../../statements/components/newStatement'
loginStatus = React.createFactory require '../../user/components/loginStatus'
header = React.createFactory require '../../header/components/header'
drawer = React.createFactory require '../../drawer/components/drawer'
{ANIMATION_START, ANIMATION_END} = require '../../util/consts'
{connect} = require 'react-redux'


appState = (state) ->
	openedStatementId: state.layout.statements.opened
	animationOpen: state.layout.statements.animationOpen
	tree: state.statementsTree


app = React.createClass

	getDefaultProps: ->
		user: null

	render: ->
		content = []
		listCssClasses = []
		statementIds = @props.tree.root

		if (isRoot = !@props.openedStatementId) or @props.animationOpen isnt ANIMATION_END
			listCssClasses.push 'root'
			content.push statementList {key: 'statementList', statementIds, cssClasses: listCssClasses}

		if @props.openedStatementId
			content.push statementOpened key: 'statementOpened'
			content.push childrenStatementList
				key: 'childrenStatementList'
				cssClasses: ['enter']
				isEntering: yes

		# content.push newStatement key: 'addStatement'

		React.DOM.div
			'className': 'app'
		, [
			header key: 'header'
			drawer key: 'drawer'
			React.DOM.main className: 'content', key: 'content', content
		]


module.exports = connect(appState) app
