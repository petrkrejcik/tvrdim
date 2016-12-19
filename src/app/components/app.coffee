React = require 'react'
statementList = React.createFactory require '../../statements/components/statementList'
childrenStatementList = React.createFactory require '../../statements/components/childrenStatementList'
statementOpened = React.createFactory require '../../statements/components/statementOpened'
newStatement = React.createFactory require '../../statements/components/newStatement'
loginStatus = React.createFactory require '../../user/components/loginStatus'
header = React.createFactory require '../../header/components/header'
drawer = React.createFactory require '../../drawer/components/drawer'
{ANIMATION_INIT, ANIMATION_START, ANIMATION_END} = require '../../util/consts'
{connect} = require 'react-redux'


appState = (state) ->
	current = state.statements[state.layout.statements.opened]
	openedStatementId: state.layout.statements.opened
	openingStatementId: state.layout.statements.openingId
	animationOpen: state.layout.statements.animationOpen
	statements: state.statements
	tree: state.statementsTree
	isGoingUp: state.layout.statements.openingId is 'root' or current?.ancestor is state.layout.statements.openingId
	isOpening: state.layout.statements.isOpening
	firstOffset: state.layout.statements.firstOffset
	openedTop: state.layout.statements.openedTop


app = React.createClass

	getDefaultProps: ->
		user: null

	render: ->
		content = []
		listCssClasses = []
		statementIds = @props.tree.root

		if @props.isOpening
			if @props.isGoingUp
				if @props.openingStatementId is 'root'
					# Animace - vracim se na root uroven
					listCssClasses.push 'root'
					if @props.animationOpen is ANIMATION_INIT
						listCssClasses.push 'appear'
					else if @props.animationOpen is ANIMATION_START
						listCssClasses.push 'enter'
					content.push statementList {
						key: 'statementList'
						statementIds
						cssClasses: listCssClasses
						storeTopOffset: yes
						isEntering: yes
						isGoingUp: yes
					}
			else if @props.openedStatementId is 'root'
				# Animation - z rootu jdu do childa
				listCssClasses.push 'root'
				listCssClasses.push 'leave'
				content.push statementList {
					key: 'statementList'
					statementIds
					cssClasses: listCssClasses
				}

		else if @props.openedStatementId is 'root'
			# proste root
			listCssClasses.push 'root'
			content.push statementList {
				key: 'statementList'
				statementIds
				cssClasses: listCssClasses
				storeTopOffset: yes
			}


		opened = @props.statements[@props.openedStatementId]
		opening = @props.statements[@props.openingStatementId]
		if @props.isOpening
			if @props.isGoingUp
				# Animation - Going up
				openedCss = []
				openingCss = []
				openingListCssClasses = []
				openedListCssClasses = []
				if @props.openingStatementId is 'root'
					# Jdu z prvniho potomka do rootu
					if @props.animationOpen is ANIMATION_INIT
						openedCss.push 'disappear'
						openedListCssClasses.push 'disappear'
					else if @props.animationOpen is ANIMATION_START
						openedCss.push 'leave'
						openedCss.push 'slide'
						openedListCssClasses.push 'leave'

					content.push statementOpened
						key: 'statementOpened'
						statement: opened
						cssClasses: openedCss
					content.push childrenStatementList
						key: 'childrenStatementList'
						childrenIds: @props.tree[opened.id]
						parent: opened
						listCssClasses: openedListCssClasses
				else
					# Jdu z xtyho potomka nahoru, co neni root
					if @props.animationOpen is ANIMATION_INIT
						openedCss.push 'disappear'
						openingCss.push 'appear'
						openingCss.push 'trans'
						openedListCssClasses.push 'disappear'
						openingListCssClasses.push 'appear'
					else if @props.animationOpen is ANIMATION_START
						openedCss.push 'leave'
						openedCss.push 'slide'
						openingCss.push 'enter'
						openedListCssClasses.push 'leave'
						openingListCssClasses.push 'enter'
					openingStyle = top: "#{@props.firstOffset.topViewport}px" # musi byt top od viewportu

					content.push statementOpened
						key: "statementOpened-#{opened.id}"
						statement: opened
						cssClasses: openedCss
					content.push childrenStatementList
						key: 'childrenStatementListOpened'
						childrenIds: @props.tree[opened.id]
						parent: opened
						listCssClasses: openedListCssClasses

					content.push statementOpened
						key: "statementOpened-#{opening.id}"
						statement: opening
						cssClasses: openingCss
						style: openingStyle
					content.push childrenStatementList
						key: 'childrenStatementListOpening'
						childrenIds: @props.tree[opening.id]
						parent: opening
						listCssClasses: openingListCssClasses

			else
				# Animation - Show children
				cssClasses = []
				listStyle = {}
				openingStyle = {}
				openedCss = []
				openingCss = []

				if opened
					# Nejsem v rootu a jdu dolu, renderuju aktualni opened, kterej zmizi bez slide
					if @props.animationOpen is ANIMATION_INIT
						openedCss.push 'disappear'
					else if @props.animationOpen is ANIMATION_START
						openedCss.push 'leave'
					content.push statementOpened
						key: 'statementOpened'
						statement: opened
						style: openingStyle
						cssClasses: openedCss

				if @props.animationOpen is ANIMATION_INIT
					cssClasses.push 'appear'
					openingCss.push 'appear'
					listStyle = top: "#{@props.firstOffset.height}px"
					openingStyle = top: "#{@props.openedTop - 6}px"
				else if @props.animationOpen is ANIMATION_START
					cssClasses.push 'enter'
					openingCss.push 'enter'
					listStyle = top: "#{@props.firstOffset.height}px"
					openingStyle = top: "#{@props.firstOffset.topViewport}px" # musi byt top od viewportu

				content.push statementOpened
					key: 'statementOpening'
					statement: opening
					style: openingStyle
					cssClasses: openingCss
				content.push childrenStatementList
					key: 'childrenStatementList'
					listCssClasses: cssClasses
					isEntering: yes
					childrenIds: @props.tree[opening.id]
					parent: opening
					style: listStyle
		else if @props.openedStatementId isnt 'root'
			# Static - opened children
			content.push statementOpened
				key: 'statementOpened'
				statement: @props.statements[@props.openedStatementId]
			content.push childrenStatementList
				key: 'childrenStatementList'
				childrenIds: @props.tree[opened.id]
				parent: opened


		React.DOM.div
			'className': 'app'
		, [
			header key: 'header'
			drawer key: 'drawer'
			React.DOM.main className: 'content', key: 'content', content
		]


module.exports = connect(appState) app
