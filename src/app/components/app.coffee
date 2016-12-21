React = require 'react'
statementFilter = React.createFactory require '../../statements/containers/statementFilter'
statementOpened = React.createFactory require '../../statements/components/statementOpened'
newStatement = React.createFactory require '../../statements/components/newStatement'
header = React.createFactory require '../../header/components/header'
drawer = React.createFactory require '../../drawer/components/drawer'
drawerOverlay = React.createFactory require '../../drawer/components/drawerOverlay'
{connect} = require 'react-redux'


appState = (state) ->
	opened: state.layout.statements.opened
	statements: state.statements
	drawer: state.layout.drawer
	tree: state.statementsTree


app = React.createClass

	getDefaultProps: ->
		user: null

	render: ->
		if @props.opened
			content = statementOpened
				opened: @props.statements[@props.opened]
		else
			content = [
				newStatement key: 'addStatement'
				React.DOM.div
					key: 'sectionMine'
					className: 'section'
				, 'My arguments'
				statementFilter
					key: 'statementFilterMine'
					cssClasses: ['root']
					filters: [
						ancestor: 'root'
					,	user: 'mine'
					]
				React.DOM.div
					key: 'sectionOthers'
					className: 'section'
				, 'Others arguments'
				statementFilter
					key: 'statementFilterAll'
					cssClasses: ['root']
					filters: [
						ancestor: 'root'
					,	user: 'notMine'
					]
			]

		React.DOM.div
			className: 'app'
		, [
			header key: 'header'
			drawer key: 'drawer' if @props.drawer.isOpened
			React.DOM.main 'className': 'content', 'key': 'content', content
			drawerOverlay key: 'drawerOverlay'
		]


module.exports = connect(appState) app
