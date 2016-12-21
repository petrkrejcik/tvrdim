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
				React.DOM.h3
					key: 'sectionMine'
					className: 'section'
				, 'My statements'
				newStatement key: 'addStatement'
				statementFilter
					key: 'statementFilterMine'
					cssClasses: ['root']
					filters: [
						ancestor: 'root'
					,	user: 'mine'
					]
				React.DOM.h3
					key: 'sectionOthers'
					className: 'section'
				, 'Other\'s statements'
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
